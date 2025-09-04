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

@onready var messages := [
	{
		from = tr("MAIL_BOSS_NAME"),
		subject = tr("MAIL_INTRO_SUBJECT"),
		body = tr("MAIL_INTRO_TEXT")
	}
]

func _init() -> void:
	TranslationServer.set_locale(OS.get_locale_language())

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
		end_text = tr("VICTORY_TEXT")
	else:
		var s: String
		for i in range(len(pet_names)):
			s += pet_names[i]
			if i + 1 != len(pet_names):
				s += ", "
		end_text = tr("FAILURE_TEXT") + " " + s
	game_window.end_game(end_text, pet_names.is_empty())
	
func popup_quest(pet_info: Dictionary) -> void:
	var popup: window = create_window(missing_dog_window, tr("WINDOW_MISSING_TITLE") + " " + pet_info["id"]) #missing_dog_window.instantiate()
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
	game_window.timed_out.connect(_on_game_timed_out)
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
		
func _on_game_timed_out() -> void:
	end_game()

func _on_world_view_window_game_started() -> void:
	start_game([
		{
			id = tr("PET_NAME_GORDA"), 
			ears = pet_structure.EARS_ROUND_LONG,
			nose = pet_structure.NOSE_ROUND,
			hair_spots_shape = pet_structure.HAIR_SPOTS_BIG,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_GREY,
			hair_color = pet_structure.HAIR_COLOR_BROWN,
			eyes = pet_structure.EYES_EYEPATCH
		},
		{
			id = tr("PET_NAME_LUCHO"),
			ears = pet_structure.EARS_POINTY,
			nose = pet_structure.NOSE_SMALL_FLAT, #Tal vez deberia ser bigflat
			hair_spots_shape = pet_structure.HAIR_SPOTS_SMALL,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_WHITE,
			hair_color = pet_structure.HAIR_COLOR_GREY,
			eyes = pet_structure.EYES_COMMON
		},
		{
			id = tr("PET_NAME_CHICHO"),
			ears = pet_structure.EARS_ROUND,
			nose = pet_structure.NOSE_NARROW,
			hair_spots_shape = pet_structure.HAIR_SPOTS_HEARTS,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_BLOND, #Este si es correcto que sea blond
			hair_color = pet_structure.HAIR_COLOR_BLACK,
			eyes = pet_structure.EYES_COMMON
		}
	])

func _on_world_view_window_dog_found(selection: String, pet: StaticBody3D):
	if selection == pet.id:
		pet_names.erase(pet.id)
	tries -= 1
	if tries == 0 or pet_names.is_empty():
		end_game()
	pet.queue_free()

func _on_end_timer_timeout() -> void:
	get_tree().quit()


func _on_mail_button_pressed() -> void:
	var w: window = create_window(mail_window, tr("ICON_MAIL"))
	if w:
		add_child(w)
		w.download_started.connect(_on_download_start)
		notify_mail.connect(w.add_item)
		for message in messages:
			w.add_item(message)
		w.global_position = Vector2(128, 64)
		
func _on_download_start() -> void:
	if %PRSIcon.visible: return
	var bar = download_bar.instantiate()
	bar.init(5)
	add_child(bar)
	await get_tree().create_timer(5).timeout
	%PRSIcon.visible = true
	await get_tree().create_timer(1).timeout
	send_mail(tr("MAIL_BOSS_NAME"), tr("MAIL_TUTORIAL_SUBJECT"), tr("MAIL_TUTORIAL_TEXT"))

func send_mail(_from: String, _subject: String, _body: String):
	messages.append({ from = _from, subject = _subject, body =  _body })
	notify_mail.emit(messages.back())
	
