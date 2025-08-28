extends Button

var master: window = null

func init(w: Node):
	master = w
	text = w.get_title()
	w.closed.connect(queue_free)

func _on_pressed() -> void:
	assert(master != null)
	master.focus()
