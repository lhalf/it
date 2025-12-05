class_name Map extends Node3D

const POWER_UP_MANAGER: PackedScene = preload("res://src/power_up/power_up_manager.tscn")

func _ready() -> void:
	add_child(POWER_UP_MANAGER.instantiate())
