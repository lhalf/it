class_name HandLeft extends Node3D

@onready var hand_animations: AnimationPlayer = %HandAnimations

@rpc("any_peer", "call_local", "reliable")
func tag() -> void:
	if !hand_animations.is_playing():
		hand_animations.play("tag")
