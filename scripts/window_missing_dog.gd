extends "res://scripts/window.gd"

var pet_structure = preload("res://scripts/pet_structure.gd")

func init(pet_info: Dictionary):
	%FurInfo.text = tr(pet_structure.describe(pet_info["hair_color"]))
	%SpotsInfo.text = tr(pet_structure.describe(pet_info["hair_spots_color"])) + ", " + tr(pet_structure.describe(pet_info["hair_spots_shape"])).to_lower()
	%EarsInfo.text = tr(pet_structure.describe(pet_info["ears"]))
	%NoseInfo.text = tr(pet_structure.describe(pet_info["nose"]))
	%EyesInfo.text = tr(pet_structure.describe(pet_info["eyes"]))
	$HBoxContainer/Body/MarginContainer/VBoxContainer/EyesForm.visible = pet_info["eyes"] != pet_structure.EYES_COMMON
	
	for form in $HBoxContainer/Body/MarginContainer/VBoxContainer.get_children():
		var n = form.get_node("Key")
		n.text = tr(n.text) + ":"

func _process(delta: float) -> void:
	super._process(delta)
	var screen_size = get_viewport_rect().size
	var this_size = get_rect().size # solo si es Control
