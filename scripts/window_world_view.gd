extends "res://scripts/window.gd"

signal game_started
signal game_ended(won: bool)

func _process(_delta: float) -> void:
	%TimerLabel.text = str(int(%Timer.time_left))

@onready var recovery_window: PanelContainer = $HBoxContainer/Body/SubViewportContainer/RecoveryWindow

func _on_start_button_pressed() -> void:
	%StartScreen.visible = false
	%TimerLabel.visible = true
	%Timer.start()
	game_started.emit()

func _on_world_dog_clicked(dog_name: String) -> void:
	recovery_window.set_global_position(get_viewport().get_mouse_position())
	recovery_window.visible = true
	print(dog_name)

func _on_timer_timeout() -> void:
	%EndScreen.visible = true

func _on_end_button_pressed() -> void:
	game_ended.emit(false)
