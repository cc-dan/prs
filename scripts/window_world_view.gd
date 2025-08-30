extends "res://scripts/window.gd"

signal game_started
signal game_ended(won: bool)
signal dog_found(selection: String, pet: StaticBody3D)
var task_bar = null

func _process(_delta: float) -> void:
	%TimerLabel.text = str(int(%Timer.time_left))
	var screen_size = get_viewport_rect().size
	var this_size = get_rect().size  # solo si es Control
	if task_bar == null:
		task_bar = get_parent().get_node("Taskbar").get_node("PanelContainer")
	var task_bar_rect = task_bar.get_rect()
		
	global_position.x = clamp(global_position.x, 0, screen_size.x - this_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y - (this_size.y + task_bar_rect.size.y))


@onready var recovery_window: PanelContainer = $HBoxContainer/Body/SubViewportContainer/RecoveryWindow

func _on_start_button_pressed() -> void:
	%StartScreen.visible = false
	%TimerLabel.visible = true
	%Timer.start()
	game_started.emit()
	%world.visible = true

func _on_world_dog_clicked(dog_name: StaticBody3D) -> void:
	if recovery_window.visible:
		return
	recovery_window.appear(dog_name)
	print("Dog clicked: ", dog_name.id)
	recovery_window.set_global_position(Vector2(
		get_viewport().get_mouse_position().x + 15,
		get_viewport().get_mouse_position().y + 15
	))
	recovery_window.visible = true

func _on_timer_timeout() -> void:
	%EndScreen.visible = true

func _on_end_button_pressed() -> void:
	game_ended.emit()

func _on_recovery_window_submit(selection: String, pet: StaticBody3D) -> void:
	recovery_window.disable_option(selection)
	dog_found.emit(selection, pet)

func end_game(end_text: String, won: bool) -> void:
	%EndText.text = end_text
	%EndScreen.visible = true
	%EndButton.text = "Continue"
