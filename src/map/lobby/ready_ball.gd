class_name ReadyBall extends RigidBody3D

@onready var mesh: MeshInstance3D = %MeshInstance3D

var is_ready: bool = false

@rpc("any_peer", "call_remote", "reliable")
func on_hit(impulse: Vector3) -> void:
	apply_impulse(impulse)
	GameManager.toggle_ready(multiplayer.get_remote_sender_id())

func on_hit_local() -> void:
	if is_ready:
		unready()
	else:
		ready()

func ready() -> void:
	mesh.mesh.material.albedo_color = Color.GREEN
	is_ready = true

func unready() -> void:
	mesh.mesh.material.albedo_color = Color.RED
	is_ready = false
