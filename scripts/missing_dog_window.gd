extends "res://scenes/window.gd"

func init(dog_name: String):
	$HBoxContainer/TitleBar/MarginContainer/Title.text += dog_name
