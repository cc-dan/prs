extends window

const mail_item_scene = preload("res://scenes/window/mail_item.tscn")

var downloaded := false

signal download_started

func _on_back_button_pressed() -> void:
	%Content.visible = false

#func _on_message_1_pressed() -> void:
	#%BodyText.text = "Welcome to the Pet Recovery Services internship program! We're excited to begin working with you. Your duty will be of very important value to the community, for which I advise to bear with me for a moment while I explain the way this works.\nAs you might know, you'll be attending to a few reports of missing pets in the area. You'll receive a list of pet descriptions, and using our specialized search & rescue software you'll have to report on their location. As you've just begun, please click the link below to download the program to your desktop.\n\n[url=download]Download[/url]\n\nGood luck!\n\nKind regards,\nKaren Tregaskin - PRS S&R operations manager"
	#%Content.visible = true

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
