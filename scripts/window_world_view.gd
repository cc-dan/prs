extends "res://scripts/window.gd"

signal game_started
signal game_ended
signal dog_found(selection: String, pet: String)

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
	recovery_window.appear(dog_name)
	print("Dog clicked: ", dog_name)

func _on_timer_timeout() -> void:
	%EndScreen.visible = true

func _on_end_button_pressed() -> void:
	game_ended.emit()


func _on_recovery_window_submit(selection: String, pet: String) -> void:
	recovery_window.disable_option(selection)
	dog_found.emit(selection, pet)

func end_game(end_text: String, won: bool) -> void:
	%EndText.text = end_text
	%EndScreen.visible = true
	%EndButton.text = "Continue"
