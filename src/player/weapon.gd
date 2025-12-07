class_name Weapon extends Node3D

@onready var movement: Movement = %Movement
@onready var shotgun: Shotgun = %Shotgun
@onready var shoot_ray: RayCast3D = %ShootRay
@onready var ui: UI = %UI

func _ready() -> void:
	shotgun.reloaded.connect(ui.set_ammo.bind(shotgun.max_rounds))

func shoot() -> void:
	if shotgun.rounds == 0:
		return
	shotgun.shoot.rpc()
	check_hit()
	if !get_parent().is_on_floor():
		movement.apply_impulse.rpc_id(1, -(global_transform.basis * shoot_ray.target_position).normalized() * shotgun.power)
	ui.set_ammo(shotgun.rounds)

func check_hit() -> void:
	if shoot_ray.is_colliding():
		var collider = shoot_ray.get_collider()
		if collider is Player:
			collider.movement.apply_impulse.rpc_id(1, global_position.direction_to(collider.global_position) * shotgun.power)
		if collider is ReadyBall:
			collider.on_hit.rpc_id(1, global_position.direction_to(collider.global_position) * shotgun.power)
			collider.on_hit_local()
