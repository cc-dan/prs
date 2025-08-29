extends Node2D

const pet_structure = preload("res://scripts/pet_structure.gd")

const missing_dog_window = preload("res://scenes/window/window_missing_dog.tscn")
const world_view_window = preload("res://scenes/window/window_world_view.tscn")

var recovery_window: window = null
var game_window: window = null

func _ready() -> void:
	pass

func start_game(objectives: Array) -> void:
	var pet_names: Array
	for pet in objectives:
		pet_names.append(pet["id"])
		popup_quest(pet)
	recovery_window.init(pet_names)
	
func popup_quest(pet_info: Dictionary) -> void:
	var popup: window = create_window(missing_dog_window, "MISSING: " + pet_info["id"]) #missing_dog_window.instantiate()
	popup.init(pet_info)
	var canvas: Vector2 = DisplayServer.window_get_size()
	popup.set_position(Vector2(randi_range(0, canvas.x / 2), randi_range(0, canvas.y / 2)))
	add_child(popup)

func create_window(window_resource: Resource, title: String) -> window:
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
	add_child(game_window)

func _on_world_view_window_game_started() -> void:
	start_game([
		{
			id = "Gorda", 
			ears = pet_structure.EARS_ROUND,
			nose = pet_structure.NOSE_BIG_ROUND,
			hair_spots_shape = pet_structure.HAIR_SPOTS_BIG,
			hair_spots_color = pet_structure.HAIR_SPOTS_COLOR_BROWN,
			hair_color = pet_structure.HAIR_COLOR_WHITE
		},
		{
			id = "Philipa",
			ears = pet_structure.EARS_ROUND,
			nose = pet_structure.NOSE_BIG_ROUND,
			hair_spots_shape = 0,
			hair_spots_color = 0,
			hair_color = pet_structure.HAIR_COLOR_GREY
		},
		{
			id = "Chicho",
			ears = pet_structure.EARS_POINTY,
			nose = pet_structure.NOSE_BIG_ROUND,
			hair_spots = pet_structure.HAIR_SPOTS_BIG,
			hair_spots_shape = 0,
			hair_spots_color = 0,
			hair_color = pet_structure.HAIR_COLOR_GREY
		}
	])
