extends "res://scripts/window.gd"

var pet_structure = preload("res://scripts/pet_structure.gd")

func init(pet_info: Dictionary):
	%FurInfo.text = pet_structure.describe(pet_info["hair_color"])
	if pet_info["hair_spots_shape"] or pet_info["hair_spots_color"]:
		assert(pet_info["hair_spots_shape"] and pet_info["hair_spots_color"]) # Evitar casos en donde solo uno de ellos viene vacío
		%FurInfo.text += " with " + (pet_structure.describe(pet_info["hair_spots_color"]) + " " + pet_structure.describe(pet_info["hair_spots_shape"])).to_lower() + " spots"
	%EarsInfo.text = pet_structure.describe(pet_info["ears"])
	%NoseInfo.text = pet_structure.describe(pet_info["nose"])
