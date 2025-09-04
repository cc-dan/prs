extends StaticBody3D

@export var id: String
@onready var animation_player: AnimationPlayer = find_child("AnimationPlayer")

@export var navigation: NavigationRegion3D
var map: RID

var idle := true
var path: PackedVector3Array
var path_index: int = 0

func _ready() -> void:
	map = navigation.get_navigation_map()
	$Idler.wait_time = randf_range(0, 2)
	$Idler.start()
	animation_player.connect("animation_finished", _on_animation_finished)

func random_point_in_circle(radius: float) -> Vector2:
	var x := randf_range(-radius, radius)
	var y := randf_range(-radius, radius)
	while (sqrt(x**2 + y**2) >= radius):
		x = randf_range(-radius, radius)
		y = randf_range(-radius, radius)
	return Vector2(x, y)
	
func set_path(to: Vector3) -> void:
	path = NavigationServer3D.map_get_path(map, global_transform.origin, to, false)
	path_index = 0

func get_next_point()->Vector3:
	if (path.is_empty()): return Vector3.ZERO
	if (global_position.distance_to(path[path_index]) <= .5):
		path_index += 1
	if (path_index >= path.size()):
		path = []
		path_index = 0
		return Vector3.ZERO
	return path[path_index]

func _physics_process(delta: float) -> void:
	if idle: return
	
	var next_point := get_next_point()
	if next_point == Vector3.ZERO:
		idle = true
		$Idler.start()
		return
		
	if global_position.distance_to(next_point) >= 1: # Hack para que look_at no lloriquee
		look_at(next_point)
	global_position += global_position.direction_to(next_point) * 3 * delta

func _on_idler_timeout() -> void:
	var point := Vector2(global_position.x, global_position.z) + random_point_in_circle(randf_range(2, 8))
	set_path(NavigationServer3D.map_get_closest_point(map, Vector3(point.x, global_position.y, point.y)))
	idle = false
	animation_player.play("Animation")
	$Idler.wait_time = randf_range(2, 5)

func _on_animation_finished(anim_name: StringName) -> void:
	animation_player.stop() if idle else animation_player.play("Animation")

func freeze() -> void:
	if not idle:
		idle = true
	else:
		$Idler.stop()
	
func unfreeze() -> void:
	$Idler.start(1)
