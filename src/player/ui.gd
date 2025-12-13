class_name UI extends Control

@onready var menu: Control = %Menu
@onready var name_edit: TextEdit = %NameEdit
@onready var name_tag: Label3D = %NameTag
@onready var shell_1: TextureRect = %Shell1
@onready var shell_2: TextureRect = %Shell2

func _toggle_menu() -> void:
	if menu.visible:
		_close_menu()
	else:
		menu.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_menu()

func _close_menu():
	menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_name_edit_text_changed() -> void:
	_change_name.rpc(name_edit.text)

@rpc("any_peer", "call_remote", "reliable")
func _change_name(new_name: String) -> void:
	if new_name.length() < 20:
		name_tag.text = new_name

func reset_ammo() -> void:
	shell_1.visible = true
	shell_2.visible = true
