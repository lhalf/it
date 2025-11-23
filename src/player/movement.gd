extends Node

@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var head: Node3D = %Head
@onready var hand: Node3D = %Hand

@export var player: Player
@export var movement_values: MovementValues

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	player.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED

func _physics_process(delta: float) -> void:
	# jumping
	if player.is_on_floor() and input_synchronizer.space_pressed:
		player.velocity.y += movement_values.jump_velocity
	
	# falling
	if not player.is_on_floor():
		player.velocity.y -= gravity * delta
	
	# directional movement
	var direction: Vector2 = input_synchronizer.direction
	var relative_input = Vector2(direction.x, direction.y).rotated(-player.global_rotation.y)
	if direction.length() > 0:
		player.velocity.x = lerp(player.velocity.x, relative_input.x * movement_values.max_speed, movement_values.acceleration * delta)
		player.velocity.z = lerp(player.velocity.z, relative_input.y * movement_values.max_speed, movement_values.acceleration * delta)
	else:
		if player.is_on_floor():
			player.velocity.x = lerp(player.velocity.x, 0.0, movement_values.friction * delta)
			player.velocity.z = lerp(player.velocity.z, 0.0, movement_values.friction * delta)
		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, movement_values.air_resistance * delta)
			player.velocity.z = lerp(player.velocity.z, 0.0, movement_values.air_resistance * delta)
	
	player.move_and_slide()

# client tells everyone else this information
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotation_degrees.y -= (event.relative.x * movement_values.sensitivity)
		var vertical_rotation_x: int = clamp(head.rotation_degrees.x + -event.relative.y * movement_values.sensitivity,
		 -movement_values.upper_clamp_angle_degrees,
		 movement_values.lower_clamp_angle_degrees)
		head.rotation_degrees.x = vertical_rotation_x
		hand.rotation_degrees.x = vertical_rotation_x
