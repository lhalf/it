class_name Weapon extends Node3D

@onready var movement: Movement = %Movement
@onready var shotgun: Shotgun = %Shotgun
@onready var shoot_ray: RayCast3D = %ShootRay

func shoot_left() -> void:
	shotgun.shoot_left.rpc()
	check_hit()
	movement.apply_impulse.rpc_id(1, -(global_transform.basis * shoot_ray.target_position).normalized() * shotgun.power)

func shoot_right() -> void:
	shotgun.shoot_right.rpc()
	check_hit()
	movement.apply_impulse.rpc_id(1, -(global_transform.basis * shoot_ray.target_position).normalized() * shotgun.power)

func check_hit() -> void:
	if shoot_ray.is_colliding():
		var collider = shoot_ray.get_collider()
		if collider is Player:
			collider.movement.apply_impulse.rpc_id(1, global_position.direction_to(collider.global_position) * shotgun.power)
