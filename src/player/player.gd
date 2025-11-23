class_name Player extends CharacterBody3D

@onready var camera_3d: Camera3D = %Camera3D
@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var movement: Node = %Movement

func _enter_tree() -> void:
	# client controls input & rotation
	# must be set in enter_tree
	# cannot use the onready var
	%InputSynchronizer.set_multiplayer_authority(name.to_int()) 
	%RotationSynchronizer.set_multiplayer_authority(name.to_int()) 

func _ready() -> void:
	var is_client: bool = name.to_int() == multiplayer.get_unique_id()
	camera_3d.current = is_client
	movement.set_process_input(is_client)
	input_synchronizer.set_process_input(is_client)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
