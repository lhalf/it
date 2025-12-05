extends Node3D

@onready var lobby_label: Label3D = %LobbyLabel

@export var label_rotation_speed: int = 100

func _process(delta: float) -> void:
	lobby_label.rotation_degrees.y += delta * label_rotation_speed
