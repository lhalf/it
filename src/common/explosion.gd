class_name Explosion extends Area3D

@onready var sound: AudioStreamPlayer3D = %Sound
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var power = 100

func _ready() -> void:
	sound.play()
	animation_player.play("explode")

func _on_sound_finished() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if multiplayer.is_server():
		if body is Player:
			body.movement.apply_impulse.rpc_id(1, global_position.direction_to(body.global_position) * power)
		if body is ShootableBody:
			body.on_hit(global_position.direction_to(body.global_position) * power)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explode":
		monitoring = false
