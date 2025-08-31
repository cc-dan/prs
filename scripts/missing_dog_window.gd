extends "res://scripts/window.gd"

var pet_structure = preload("res://scripts/pet_structure.gd")

var task_bar = null

func init(pet_info: Dictionary):
	%FurInfo.text = pet_structure.describe(pet_info["hair_color"])
	if pet_info["hair_spots_shape"] or pet_info["hair_spots_color"]:
		assert(pet_info["hair_spots_shape"] and pet_info["hair_spots_color"]) # Evitar casos en donde solo uno de ellos viene vacío
		%FurInfo.text += " with " + (pet_structure.describe(pet_info["hair_spots_color"]) + " " + pet_structure.describe(pet_info["hair_spots_shape"])).to_lower() + " spots"
	%EarsInfo.text = pet_structure.describe(pet_info["ears"])
	%NoseInfo.text = pet_structure.describe(pet_info["nose"])
	%EyesInfo.text = pet_structure.describe(pet_info["eyes"])
	

func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size
	var this_size = get_rect().size  # solo si es Control
	if task_bar == null:
		task_bar = get_parent().get_node("Taskbar").get_node("PanelContainer")
	var task_bar_rect = task_bar.get_rect()
		
	global_position.x = clamp(global_position.x, 0, screen_size.x - this_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y - (this_size.y + task_bar_rect.size.y))
