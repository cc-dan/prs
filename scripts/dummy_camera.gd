extends Camera3D

var time := 0.0

const origin := Vector3.UP * 1.5 + Vector3.BACK * 1.5
const to := origin + Vector3.LEFT * 2

func _physics_process(delta: float) -> void:
	time += delta
	transform.origin = lerp(origin, to, sin(time))
