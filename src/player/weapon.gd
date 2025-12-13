class_name Weapon extends Node3D

@onready var movement: Movement = %Movement

@onready var shotgun: Shotgun = %Shotgun
@onready var shoot_ray: RayCast3D = %ShootRay
@onready var shoot_point: Marker3D = %ShootPoint

@onready var ui: UI = %UI

func _ready() -> void:
	shotgun.left_fired.connect(func(): ui.shell_1.visible = false)
	shotgun.right_fired.connect(func(): ui.shell_2.visible = false)
	shotgun.reloaded.connect(ui.reset_ammo)

func shoot() -> void:
	if shotgun.rounds == 0:
		return
	shotgun.shoot.rpc()
	_check_hit()
	if !get_parent().is_on_floor():
		movement.apply_impulse.rpc_id(1, -shoot_ray.global_position.direction_to(shoot_point.global_position) * shotgun.self_knockback)

func _check_hit() -> void:
	if shoot_ray.is_colliding():
		var collider = shoot_ray.get_collider()
		if collider is Player:
			collider.movement.apply_impulse.rpc_id(1, global_position.direction_to(collider.global_position) * shotgun.enemy_knockback)
		if collider is ReadyBall:
			collider.on_hit.rpc_id(1, global_position.direction_to(collider.global_position) * shotgun.enemy_knockback)
			collider.on_hit_local()
		if collider is ShootableBody:
			collider.on_hit.rpc_id(1, global_position.direction_to(collider.global_position) * shotgun.enemy_knockback)
