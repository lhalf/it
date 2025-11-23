class_name Shotgun extends Node3D

@onready var animations: AnimationPlayer = %AnimationPlayer

# currently only for animations etc
@rpc("any_peer", "call_local", "reliable")
func shoot_left() -> void:
	animations.play("shoot_left")

@rpc("any_peer", "call_local", "reliable")
func shoot_right() -> void:
	animations.play("shoot_right")
