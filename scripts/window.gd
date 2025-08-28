extends PanelContainer

var held := false
var cursor_offset = null

func close() -> void:
	queue_free()

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			self.move_to_front()
			cursor_offset = get_global_mouse_position() - global_position
		else:
			cursor_offset = null
	if event is InputEventMouseMotion and cursor_offset:
		global_position = get_global_mouse_position() - cursor_offset

func _on_close_pressed() -> void:
	close()
