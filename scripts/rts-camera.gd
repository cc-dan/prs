extends Node3D

@export var pan_speed: float = 0.05  # sensibilidad del arrastre
var dragging: bool = false
var last_mouse_pos: Vector2
@onready var camera_3d: Camera3D = $Base/Camera3D

func _ready():
	rotation_degrees = Vector3(-60, 0, 0)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_pos = event.position
			else:
				dragging = false
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if camera_3d.fov >= 5:
				camera_3d.fov -= 2
			else:
				camera_3d.fov = 5
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if camera_3d.fov <= 45:
				camera_3d.fov += 2
			else:
				camera_3d.fov = 45

	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		last_mouse_pos = event.position

		var move = Vector3(-delta.x, 0, -delta.y) * pan_speed
		global_translate(move)
		
