class_name Shotgun extends Node3D

const shell_scene = preload("res://src/weapons/shotgun/shell.tscn")

@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var shoot_sound: AudioStreamPlayer3D = %ShootSound
@onready var shell_spawn: Node3D = %ShellSpawn

@export var power: int = 35
@export var reloading: bool = false

enum Barrel { LEFT, RIGHT }

var current_barrel: Barrel = Barrel.LEFT

# currently only for animations etc
@rpc("any_peer", "call_local", "reliable")
func shoot() -> void:
	if current_barrel == Barrel.LEFT:
		fire("shoot_left")
		current_barrel = Barrel.RIGHT
	elif current_barrel == Barrel.RIGHT:
		fire("shoot_right")
		reloading = true
		%ReloadTimer.start()

func fire(animation_name: String) -> void:
	shoot_sound.play()
	animations.play(animation_name)
	release_shell()

func release_shell() -> void:
	var shell: RigidBody3D = shell_scene.instantiate()
	shell.position = shell_spawn.global_position
	shell.linear_velocity = Vector3(0,6,0)
	shell.angular_velocity = Vector3(0,0,10)
	add_child(shell)

func reload() -> void:
	reloading = false
	current_barrel = Barrel.LEFT
