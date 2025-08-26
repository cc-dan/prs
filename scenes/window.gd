extends PanelContainer


func _on_title_bar_gui_input(event: InputEvent) -> void:
	print("clicked")
	if event.is_action_pressed("lclick"):
		print("clicked")
		set_position(get_viewport().get_mouse_position())
