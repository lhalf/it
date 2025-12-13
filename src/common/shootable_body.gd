class_name ShootableBody extends RigidBody3D

var on_hit_effect: Callable = _do_nothing

@rpc("any_peer", "call_remote", "reliable")
func on_hit(impulse: Vector3) -> void:
	apply_impulse(impulse)
	on_hit_effect.rpc()

# this is so we can rpc it in the override method
@rpc("authority", "call_local", "reliable")
func _do_nothing() -> void:
	pass
