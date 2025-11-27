class_name Shotgun extends Node3D

const shell_scene = preload("res://src/weapons/shotgun/shell.tscn")

@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var shoot_sound: AudioStreamPlayer3D = %ShootSound
@onready var shell_spawn: Node3D = %ShellSpawn

@export var power: int = 35

# currently only for animations etc
@rpc("any_peer", "call_local", "reliable")
func shoot_left() -> void:
	shoot_sound.play()
	animations.play("shoot_left")
	release_shell()

@rpc("any_peer", "call_local", "reliable")
func shoot_right() -> void:
	shoot_sound.play()
	animations.play("shoot_right")
	release_shell()

func release_shell() -> void:
	var shell: RigidBody3D = shell_scene.instantiate()
	shell.position = shell_spawn.global_position
	shell.linear_velocity = Vector3(0,6,0)
	shell.angular_velocity = Vector3(0,0,10)
	add_child(shell)
