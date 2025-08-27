extends "res://scripts/window.gd"

@onready var radio: ButtonGroup = $HBoxContainer/Body/MarginContainer/VBoxContainer/HBoxContainer/CheckBox.button_group

func _on_button_pressed() -> void:
	super.close()
