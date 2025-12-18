extends Node3D

@export var speed = 4

func _ready() -> void:
	$Ship/AnimationPlayer.play("ship_sway")

func _process(delta: float) -> void:
	if multiplayer.is_server():
		rotation_degrees.y += speed * delta
