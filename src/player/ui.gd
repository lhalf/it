class_name UI extends Control

@onready var ammo: Label = %Ammo

func set_ammo(amount: int) -> void:
	ammo.text = str(amount)
