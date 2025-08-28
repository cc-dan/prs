extends "res://scripts/window.gd"

signal game_started

@onready var recovery_window: PanelContainer = $HBoxContainer/Body/SubViewportContainer/RecoveryWindow


func init(npets: int) -> void:
	%PetsCounter.text = str(npets) + " missing pets"

func close() -> void:
	visible = false

>>>>>>> a2174de (Abrir windowrecovery al clickear en un perro)
func _on_start_button_pressed() -> void:
	%StartScreen.visible = false
	game_started.emit()

func _on_world_dog_clicked(dog_name: String) -> void:
	recovery_window.set_global_position(get_viewport().get_mouse_position())
	recovery_window.visible = true
	print(dog_name)
