class_name MapManager extends Node

@onready var current_map: Node = %CurrentMap

func _ready() -> void:
	GameManager.on_all_ready.connect(change_map)

func change_map(map: PackedScene) -> void:
	remove_map()
	current_map.add_child(map.instantiate())

func remove_map() -> void:
	for map: Node3D in current_map.get_children():
		current_map.remove_child(map)
		map.queue_free()
