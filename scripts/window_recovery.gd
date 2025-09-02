extends "res://scripts/window.gd"

@onready var boxes: Array = [ %CheckBox, %CheckBox2, %CheckBox3 ]
@onready var container = $"../.."

var selected_pet: StaticBody3D

signal submit(selection_id: String, pet: StaticBody3D)

func appear(pet: StaticBody3D) -> void:
	selected_pet = pet
	selected_pet.set_physics_process(false)
	visible = true

func vanish() -> void:
	selected_pet.set_physics_process(true)
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
	
func _process(delta: float) -> void:
	if visible:
		var container_rect = get_parent().get_global_rect()
		var this_rect = get_rect()
		
		var min_x = container_rect.position.x
		var min_y = container_rect.position.y
		var max_x = container_rect.position.x + container_rect.size.x - this_rect.size.x
		var max_y = container_rect.position.y + container_rect.size.y - this_rect.size.y
		
		global_position.x = clamp(global_position.x, min_x, max_x)
		global_position.y = clamp(global_position.y, min_y, max_y)
