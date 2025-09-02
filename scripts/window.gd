class_name window extends PanelContainer

var held := false
var cursor_offset = null

var task_bar = null

signal closed

func set_title(title: String) -> void:
	%Title.text = title

func close() -> void:
	closed.emit()
	queue_free()

func focus() -> void:
	visible = true
	self.move_to_front()

func get_title() -> String:
	return %Title.text

func _process(delta) -> void:
	var screen_size = get_viewport_rect().size
	var this_size = get_rect().size  # solo si es Control
	if task_bar == null:
		task_bar = get_taskbar()
	var task_bar_rect = task_bar.get_rect()
		
	global_position.x = clamp(global_position.x, 0, screen_size.x - this_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y - (this_size.y + task_bar_rect.size.y))

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			focus()
			cursor_offset = get_global_mouse_position() - global_position
		else:
			cursor_offset = null
	if event is InputEventMouseMotion and cursor_offset:
		global_position = get_global_mouse_position() - cursor_offset

func _on_close_pressed() -> void:
	close()

func get_taskbar() -> Control:
	return get_parent().get_node("Taskbar").get_node("PanelContainer")
