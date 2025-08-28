extends "res://scripts/window.gd"

signal game_started

func _on_start_button_pressed() -> void:
	%StartScreen.visible = false
	game_started.emit()
