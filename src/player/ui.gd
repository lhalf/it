class_name UI extends Control

@onready var ammo: Label = %Ammo
@onready var menu: Control = %Menu

func set_ammo(amount: int) -> void:
	ammo.text = str(amount)

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
