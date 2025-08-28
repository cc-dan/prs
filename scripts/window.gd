class_name window extends PanelContainer

var held := false
var cursor_offset = null

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
