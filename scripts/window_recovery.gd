extends "res://scripts/window.gd"

@onready var boxes: Array = [ %CheckBox, %CheckBox2, %CheckBox3 ]

var selected_pet: String

signal submit(selection_id: String, pet_id: String)

func appear(pet_id: String) -> void:
	visible = true
	selected_pet = pet_id

func vanish() -> void:
	visible = false
	for box in boxes:
		box.button_pressed = false

func init(options: Array) -> void:
	assert(len(options) == 3)
	for i in range(len(boxes)):
		boxes[i].text = options[i]

func get_selection() -> String:
	for box in boxes:
		if not box.disabled and box.button_pressed:
			return box.text
	return ""

func _on_submit_pressed() -> void:
	var selection := get_selection()
	if (len(selection)):
		submit.emit(selection, selected_pet)
		vanish()

func disable_option(id: String) -> void:
	for box in boxes:
		if box.text == id: box.disabled = true

func _on_cancel_pressed() -> void:
	vanish()
