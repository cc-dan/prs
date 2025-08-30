extends CenterContainer

func init(duration: float):
	%Timer.wait_time = duration

func _process(delta: float) -> void:
	if %Timer.time_left < 1: 
		queue_free()
	%Bar.value = %Bar.max_value / %Timer.time_left
