extends Node2D

const pet_structure = preload("res://scripts/pet_structure.gd")

var missing_dog_window = preload("res://scenes/window/window_missing_dog.tscn")

func _ready() -> void:
	start_game([
		{
			id = "Gorda", 
			ears = pet_structure.EARS_POINTY,
			nose = pet_structure.NOSE_BIG_ROUND,
			hair_spots = pet_structure.HAIR_SPOTS_BIG
		},
		{	
			id = "Filipa",
			ears = pet_structure.EARS_POINTY,
			nose = pet_structure.NOSE_BIG_ROUND,
			hair_spots = pet_structure.HAIR_SPOTS_BIG
		},
		{
			id = "Chicho",
			ears = pet_structure.EARS_POINTY,
			nose = pet_structure.NOSE_BIG_ROUND,
			hair_spots = pet_structure.HAIR_SPOTS_BIG
		}
	])

func start_game(objectives: Array) -> void:
	#%RecoveryWindow.visible = false
	var pet_names: Array
	for pet in objectives:
		pet_names.append(pet["id"])
		popup_quest(pet)
	%RecoveryWindow.init(pet_names)
	
func popup_quest(pet_info: Dictionary) -> void:
	var window: Control = missing_dog_window.instantiate()
	window.init(pet_info)
	var canvas: Vector2 = DisplayServer.window_get_size()
	window.set_position(Vector2(randi_range(0, canvas.x / 2), randi_range(0, canvas.y / 2)))
	$Secondary.add_child(window)
