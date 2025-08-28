extends "res://scripts/window.gd"

signal game_started

func init(npets: int) -> void:
	%PetsCounter.text = str(npets) + " missing pets"

func close() -> void:
	visible = false


func _on_start_button_pressed() -> void:
	%StartScreen.visible = false
	game_started.emit()
