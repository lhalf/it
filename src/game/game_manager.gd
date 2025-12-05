extends Node

signal on_all_ready(PackedScene)

var players_ready: Array = []

func setup() -> void:
	multiplayer.peer_disconnected.connect(player_unready)

func toggle_ready(id: int) -> void:
	if players_ready.has(id):
		players_ready.erase(id)
	else:
		players_ready.push_back(id)
	if players_ready.size() == 2:
		Debug.log("everyone ready!")
		on_all_ready.emit(load("res://src/map/docks/map.tscn"))
		
func player_unready(id: int) -> void:
	players_ready.erase(id)
