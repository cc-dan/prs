class_name mail_item extends HBoxContainer

var body: String

signal pressed(text: String)

func init(subject: String, _body: String, from: String) -> void:
	%Subject.text = subject
	%From.text = from
	body = _body


func _on_subject_pressed() -> void:
	pressed.emit(body)
