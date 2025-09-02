extends "res://scripts/window.gd"

signal game_started
signal game_ended
signal timed_out
signal dog_found(selection: String, pet: StaticBody3D)

func _process(_delta: float) -> void:
	super._process(_delta)
	%TimerLabel.text = str(int(%Timer.time_left))

@onready var recovery_window: PanelContainer = $HBoxContainer/Body/SubViewportContainer/RecoveryWindow

func _on_start_button_pressed() -> void:
	%StartScreen.visible = false
	%TimerLabel.visible = true
	%Timer.start()
	game_started.emit()
	%world.interactable = true

func _on_world_dog_clicked(dog_name: StaticBody3D) -> void:
	if recovery_window.visible:
		return
	recovery_window.appear(dog_name)
	recovery_window.set_global_position(Vector2(
		get_viewport().get_mouse_position().x + 15,
		get_viewport().get_mouse_position().y + 15
	))
	recovery_window.visible = true

func _on_timer_timeout() -> void:
	timed_out.emit()

func _on_end_button_pressed() -> void:
	game_ended.emit()

func _on_recovery_window_submit(selection: String, pet: StaticBody3D) -> void:
	recovery_window.disable_option(selection)
	dog_found.emit(selection, pet)

func end_game(end_text: String, won: bool) -> void:
	%Timer.stop()
	%EndText.text = end_text
	%EndScreen.visible = true
	%EndButton.text = tr("CONTINUE")
