extends window

const mail_item_scene = preload("res://scenes/window/mail_item.tscn")

var downloaded := false

signal download_started

func _on_back_button_pressed() -> void:
	%Content.visible = false

func _on_body_text_meta_clicked(meta: Variant) -> void:
	if downloaded: return
	downloaded = true
	download_started.emit()
	%Content.visible = false

func add_item(content):
	var item: mail_item = mail_item_scene.instantiate()
	item.init(content["subject"], content["body"], content["from"])
	item.pressed.connect(_on_item_pressed)
	%List.add_child(item)

func _on_item_pressed(body_text: String) -> void:
	%BodyText.text = body_text
	%Content.visible = true
