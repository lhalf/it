class_name Player extends CharacterBody3D

@export var is_it = false:
	set(value):
		if value == is_it:
			return
		
		is_it = value
		
		tag_status.it_effects_everyone(is_it)
		
		if is_client:
			tag_status.it_effects_client(is_it)

@onready var camera_3d: Camera3D = %Camera3D
@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var movement: Node = %Movement
@onready var ui: Control = %UI
@onready var player_area: PlayerArea = %PlayerArea

@onready var tag_status: TagStatus = %TagStatus

@onready var body: MeshInstance3D = %Body
@onready var outline: MeshInstance3D = %Outline
@onready var glasses: Node3D = %Glasses

var is_client: bool = false

func _enter_tree() -> void:
	# client controls input & rotation
	# must be set in enter_tree
	# cannot use the onready var
	%InputSynchronizer.set_multiplayer_authority(name.to_int()) 
	%RotationSynchronizer.set_multiplayer_authority(name.to_int()) 

func _ready() -> void:
	is_client = name.to_int() == multiplayer.get_unique_id()
	
	# visibility
	camera_3d.current = is_client
	body.set_layer_mask_value(1, !is_client)
	outline.set_layer_mask_value(1, !is_client)
	glasses.visible = !is_client
	
	# networking ownership
	movement.set_process_input(is_client)
	input_synchronizer.set_process_input(is_client)
	
	# area monitoring
	player_area.monitorable = is_client
	
	# dont hit own tag hand
	if is_client:
		collision_layer = 1
	
	# UI
	ui.set_process_input(is_client)
	ui.visible = is_client
