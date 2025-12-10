class_name Shotgun extends Node3D

const shell_scene = preload("res://src/weapons/shotgun/shell.tscn")

signal reloaded

@onready var animations: AnimationPlayer = %AnimationPlayer
@onready var shoot_sound: AudioStreamPlayer3D = %ShootSound
@onready var shell_spawn: Node3D = %ShellSpawn
@onready var reload_sound: AudioStreamPlayer3D = %ReloadSound

@export var self_knockback: int = 15
@export var enemy_knockback: int = 30

@export var max_rounds: int = 2
@export var rounds = max_rounds

enum Barrel { LEFT, RIGHT }

var current_barrel: Barrel = Barrel.LEFT

@rpc("any_peer", "call_local", "reliable")
func shoot() -> void:
	rounds -= 1
	if current_barrel == Barrel.LEFT:
		fire("shoot_left")
		current_barrel = Barrel.RIGHT
	elif current_barrel == Barrel.RIGHT:
		fire("shoot_right")
		if multiplayer.get_unique_id() == multiplayer.get_remote_sender_id():
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
	# we might have reloaded by power up before the timer
	if rounds == max_rounds:
		return
	reload_sound.play()
	current_barrel = Barrel.LEFT
	rounds = max_rounds
	reloaded.emit()
