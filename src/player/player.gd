class_name Player extends CharacterBody3D

@onready var camera_3d: Camera3D = %Camera3D
@onready var input_synchronizer: MultiplayerSynchronizer = %InputSynchronizer
@onready var movement: Node = %Movement
@onready var ui: Control = %UI
@onready var pick_up_area: PickUpArea = %PickUpArea

@onready var body: MeshInstance3D = %Body
@onready var outline: MeshInstance3D = %Outline
@onready var glasses: Node3D = %Glasses

func _enter_tree() -> void:
	# client controls input & rotation
	# must be set in enter_tree
	# cannot use the onready var
	%InputSynchronizer.set_multiplayer_authority(name.to_int()) 
	%RotationSynchronizer.set_multiplayer_authority(name.to_int()) 

func _ready() -> void:
	var is_client: bool = name.to_int() == multiplayer.get_unique_id()
	camera_3d.current = is_client
	_set_visible_to_client(is_client)
	movement.set_process_input(is_client)
	input_synchronizer.set_process_input(is_client)
	pick_up_area.monitorable = is_client
	ui.visible = is_client

func _set_visible_to_client(is_client: bool) -> void:
	body.set_layer_mask_value(1, !is_client)
	outline.set_layer_mask_value(1, !is_client)
	glasses.visible = !is_client
