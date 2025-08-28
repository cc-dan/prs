extends Control

var taskbar_item := preload("res://scenes/taskbar/taskbar_item.tscn")

func _process(_delta: float) -> void:
	%DateTime.text = Time.get_time_string_from_system()

func add_program(window_node: window):
	var item = taskbar_item.instantiate()
	item.init(window_node)
	%Programs.add_child(item)
