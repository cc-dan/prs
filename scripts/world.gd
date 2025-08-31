extends Node3D
@onready var camera: Node3D = $camera/Base/Camera3D
@onready var recovery_window: PanelContainer = $"../../RecoveryWindow"

var interactable := false

var is_clicking_a_dog: bool = false
var is_choosing: bool = false
signal dog_clicked(dog_name: StaticBody3D)

func cast_ray(mask: int) -> Dictionary:
	const RAY_LENGTH = 1000.0
	var space_state = get_world_3d().direct_space_state
	var from = camera.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * RAY_LENGTH
	#El tercer parametro es para setear la mascara de collision, y esta es un 
	#entero para poder cumplir con todas las combinaciones de la mascara de la 1 a la 20
	# Si se quiere que solo este en la capa n, la mascara debe estar en 1 << (n - 1), por lo tanto
	# 1 << 1 hace que solo este en la capa 2. 
	var query = PhysicsRayQueryParameters3D.create(from, to, 1 << mask - 1) 
	query.set_collide_with_areas(true)
	var result = space_state.intersect_ray(query)
	return result

func _process(_delta: float) -> void:
	if not interactable: return
	
	var result: Dictionary = cast_ray(2)
	
	if recovery_window.visible: 
		is_clicking_a_dog = false
		return;

	if Input.is_action_just_pressed("lclick"):
		is_clicking_a_dog = true
	
	if result.size() <= 0: 
		is_clicking_a_dog = false;
	
	if Input.is_action_just_released("lclick") and is_clicking_a_dog:
		var instance = result["collider"]
		dog_clicked.emit(instance)
