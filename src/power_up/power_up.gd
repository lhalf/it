class_name PowerUp extends ShootableBody

const EXPLOSION: PackedScene = preload("res://src/common/explosion.tscn")

@onready var mesh_instance_3d: MeshInstance3D = %MeshInstance3D
@onready var pick_up_area: Area3D = %PickUpArea

@export var type: Type

enum Type { SPEED, RELOAD, INVISIBLE, EXPLODE }

var colors : Dictionary = {
	Type.SPEED: Color.GREEN,
	Type.RELOAD: Color.SADDLE_BROWN,
	Type.INVISIBLE: Color.WHITE,
	Type.EXPLODE: Color.RED
}

func _ready() -> void:
	_set_color(colors.get(type))
	if type == Type.EXPLODE:
		on_hit_effect = _spawn_explosion

func _set_color(color: Color) -> void:
	var material = StandardMaterial3D.new()
	material.resource_local_to_scene = true
	material.albedo_color = color
	mesh_instance_3d.material_overlay = material

func _on_pick_up_area_area_entered(area: Area3D) -> void:
	if area is PlayerArea:
		Signals.rpc_id(1, "alert_power_up", type)
		_delete.rpc_id(1)

@rpc("any_peer", "call_remote", "reliable")
func _delete() -> void:
	queue_free()

@rpc("authority", "call_local", "reliable")
func _spawn_explosion() -> void:
	_disable()
	on_hit_effect = _do_nothing
	var explosion = EXPLOSION.instantiate()
	explosion.position = global_position
	add_child(explosion)
	if multiplayer.is_server():
		explosion.tree_exited.connect(func(): queue_free())

func _disable() -> void:
	mesh_instance_3d.hide()
	pick_up_area.monitoring = false
