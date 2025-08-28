extends "res://scripts/window.gd"

var pet_structure = preload("res://scripts/pet_structure.gd")

func init(pet_info: Dictionary):
	%Title.text += pet_info["id"]
	%SpotsInfo.text = pet_structure.describe(pet_info["hair_spots"])
	%EarsInfo.text = pet_structure.describe(pet_info["ears"])
	%NoseInfo.text = pet_structure.describe(pet_info["nose"])
