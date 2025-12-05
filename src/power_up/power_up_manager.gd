class_name PowerUpManager extends Node3D

const POWER_UP: PackedScene = preload("res://src/power_up/power_up.tscn")

@onready var power_up_area: Area3D = %PowerUpArea
@onready var power_ups: Marker3D = %PowerUps
@onready var spawn_timer: Timer = %SpawnTimer

func _ready() -> void:
	if multiplayer.is_server():
		spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	_spawn_power_up()

func _spawn_power_up() -> void:
	var power_up: PowerUp = POWER_UP.instantiate()
	power_up.position = _get_random_point_in_area(power_up_area)
	power_ups.add_child(power_up, true)

func _get_random_point_in_area(area: Area3D) -> Vector3:
	var shape = area.get_node("CollisionShape3D").shape
	var extents = shape.extents
	var x = randf_range(-extents.x, extents.x)
	var y = randf_range(-extents.y, extents.y)
	var z = randf_range(-extents.z, extents.z)
	return area.to_global(Vector3(x, y, z))
