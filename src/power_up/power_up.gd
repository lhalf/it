class_name PowerUp extends RigidBody3D

@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D

@export var type: Type

enum Type { SPEED }

var colors : Dictionary = {
	Type.SPEED: Color.GREEN
}

func _ready() -> void:
	_setup_random()

func _setup_random() -> void:
	var random_type: Type = randi_range(0, Type.size() - 1) as Type
	type = random_type
	var color: Color = colors.get(random_type)
	_set_color(color)

func _set_color(color: Color) -> void:
	mesh_instance_3d.mesh.material.albedo_color = color

func _on_pick_up_area_body_entered(body: Node3D) -> void:
	if body is Player and multiplayer.is_server():
		queue_free()
