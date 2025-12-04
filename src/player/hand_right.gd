extends Node3D

@export var player: Player
@export var head: Node3D
@export var hand: Node3D
@export var hand_location: Marker3D

@export var sway: int = 20

func _process(delta: float) -> void:
	hand.global_position = hand_location.global_position
	hand.rotation.z = 0
	hand.rotation.y = lerp_angle(hand.rotation.y, player.rotation.y, sway * delta)
	hand.rotation.x = lerp_angle(hand.rotation.x, head.rotation.x, sway * delta)
