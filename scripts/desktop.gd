extends Node2D

const pet_structure = preload("res://scripts/pet_structure.gd")

const missing_dog_window = preload("res://scenes/window/window_missing_dog.tscn")
const world_view_window = preload("res://scenes/window/window_world_view.tscn")
const mail_window = preload("res://scenes/window/window_mail.tscn")

const download_bar = preload("res://scenes/download_bar.tscn")

var recovery_window: window = null
var game_window: window = null
var pet_names: Array = []
var tries: int

signal notify_mail(content)

var messages := [
	{
		from = "Karen Tregaskin",
		subject = "Your first day on the job",
		body = "Welcome to the Pet Recovery Services internship program! We're excited to begin working with you. Your duty will be of very important value to the community, for which I advise to bear with me for a moment while I explain the way this works.\nAs you might know, you'll be attending to a few reports of missing pets in the area. You'll receive a list of pet descriptions, and using our specialized search & rescue software you'll have to report on their location. As you've just begun, please click the link below to download the program to your desktop. I'll tell you how to use it once you download it.\n\n[color=blue][url=download]Download[/url][/color]\n\nGood luck!\n\nKind regards,\nKaren Tregaskin - PRS S&R operations manager"
	}
]

func _ready() -> void:
	TransitionScreen.transition(true)

func start_game(objectives: Array) -> void:
	pet_names = []
	for pet in objectives:
		pet_names.append(pet["id"])
		popup_quest(pet)
	tries = len(pet_names)
	recovery_window.init(pet_names)
	
func end_game() -> void:
	var end_text: String
	if pet_names.is_empty():
		end_text = "Congratulations, you have found them all!"
	else:
		var s: String
		for i in range(len(pet_names)):
			s += pet_names[i]
			if i + 1 != len(pet_names):
				s += ", "
		end_text = "Too bad! Seems you made a mistake. These remain missing: " + s
	game_window.end_game(end_text, pet_names.is_empty())
	
func popup_quest(pet_info: Dictionary) -> void:
	var popup: window = create_window(missing_dog_window, "MISSING: " + pet_info["id"]) #missing_dog_window.instantiate()
	popup.init(pet_info)
	var canvas: Vector2 = DisplayServer.window_get_size()
	popup.set_position(Vector2(randi_range(0, canvas.x / 2), randi_range(0, canvas.y / 2)))
	add_child(popup)

func create_window(window_resource: Resource, title: String) -> window:
	for n in get_children():
		if n is window and n.get_title() == title:
			n.focus()
			return null
	var w: window = window_resource.instantiate()
	w.set_title(title)
	w.focus()
	%Taskbar.add_program(w)
	return w

func _on_world_view_icon_pressed() -> void:
	if game_window: return
	game_window = create_window(world_view_window, "Conurbanview")
	recovery_window = game_window.get_node("HBoxContainer/Body/SubViewportContainer/RecoveryWindow")
	game_window.game_started.connect(_on_world_view_window_game_started)
	game_window.dog_found.connect(_on_world_view_window_dog_found)
	game_window.game_ended.connect(_on_game_ended)
	add_child(game_window)

func _on_game_ended() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	if pet_names.is_empty():
		%EndScreen.move_to_front()
		%EndScreen.visible = true
		%EndTimer.start()
	else:
		get_tree().reload_current_scene()

func _on_world_view_window_game_started() -> void:
	start_game([
		{
			id = "Gorda", 
			ears = pet_structure.EARS_ROUND_LONG,
			nose = pet_structure.NOSE_ROUND,
			hair_spots_shape = pet_structure.HAIR_SPOTS_BIG,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_WHITE,
			hair_color = pet_structure.HAIR_COLOR_BROWN,
			eyes = pet_structure.EYES_EYEPATCH
		},
		{
			id = "Lucho",
			ears = pet_structure.EARS_POINTY,
			nose = pet_structure.NOSE_SMALL_FLAT, #Tal vez deberia ser bigflat
			hair_spots_shape = pet_structure.HAIR_SPOTS_SMALL,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_WHITE,
			hair_color = pet_structure.HAIR_COLOR_GREY,
			eyes = pet_structure.EYES_COMMON
		},
		{
			id = "Chicho",
			ears = pet_structure.EARS_ROUND,
			nose = pet_structure.NOSE_NARROW,
			hair_spots_shape = pet_structure.HAIR_SPOTS_HEARTS,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_BLOND, #Este si es correcto que sea blond
			hair_color = pet_structure.HAIR_COLOR_GREY,
			eyes = pet_structure.EYES_COMMON
		}
	])

func _on_world_view_window_dog_found(selection: String, pet: StaticBody3D):
	print("Dog found: ", pet.id, ", submitted as ", selection)
	if selection == pet.id:
		pet_names.erase(pet.id)
		print("It's a match")
	tries -= 1
	if tries == 0 or pet_names.is_empty():
		end_game()
	pet.queue_free()

func _on_end_timer_timeout() -> void:
	get_tree().quit()


func _on_mail_button_pressed() -> void:
	var w: window = create_window(mail_window, "Mail")
	if w:
		add_child(w)
		w.download_started.connect(_on_download_start)
		notify_mail.connect(w.add_item)
		for message in messages:
			w.add_item(message)
		w.global_position = Vector2(128, 64)
		
func _on_download_start() -> void:
	if %PRSIcon.visible: return
	print("Downloading...")
	var bar = download_bar.instantiate()
	bar.init(5)
	add_child(bar)
	await get_tree().create_timer(5).timeout
	%PRSIcon.visible = true
	await get_tree().create_timer(1).timeout
	send_mail("Karen Tregaskin", "Program instructions", "Good job! The program presents you with a top down view of the town. [b]Click and drag with the mouse[/b] to move the camera. Use the [b]scroll wheel[/b] to zoom in so you get all the little details on the pets roaming around! Once you think you've found a missing pet, [b]click on it[/b] to tell us which one you found.\n\nOnce again, good luck. You have a limited time before your shift ends, try to find all reported missing pets if possible!\n\nKaren Tregaskin - S&R operations manager")

func send_mail(_from: String, _subject: String, _body: String):
	messages.append({ from = _from, subject = _subject, body =  _body })
	notify_mail.emit(messages.back())
	
