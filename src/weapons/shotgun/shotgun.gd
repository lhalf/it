class_name Shotgun extends Node3D

@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var shoot_sound: AudioStreamPlayer3D = %ShootSound

# currently only for animations etc
@rpc("any_peer", "call_local", "reliable")
func shoot_left() -> void:
	shoot_sound.play()
	animations.play("shoot_left")

@rpc("any_peer", "call_local", "reliable")
func shoot_right() -> void:
	shoot_sound.play()
	animations.play("shoot_right")
