class_name ShootableBody extends RigidBody3D

@rpc("any_peer", "call_remote", "reliable")
func on_hit(impulse: Vector3) -> void:
	apply_impulse(impulse)
