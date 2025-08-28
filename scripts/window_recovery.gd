extends "res://scripts/window.gd"

@onready var boxes: Array = [ %CheckBox, %CheckBox2, %CheckBox3 ]

func init(options: Array) -> void:
	assert(len(options) == 3)
	for i in range(len(boxes)):
		boxes[i].text = options[i]

func get_selection() -> String:
	for box in boxes:
		if box.button_pressed:
			return box.text
	return ""

func _on_submit_pressed() -> void:
	visible = false
