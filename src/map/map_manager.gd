class_name MapManager extends Node

@onready var current_map: Node = %CurrentMap

func change_map(map: PackedScene) -> void:
	for child in current_map.get_children():
		remove_child(child)
		child.queue_free()
	current_map.add_child(map.instantiate())
