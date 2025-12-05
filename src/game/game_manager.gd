extends Node # GameManager

signal on_all_ready(PackedScene)

var players_ready: PackedInt32Array = []

func _ready() -> void:
	multiplayer.peer_disconnected.connect(player_unready)

func toggle_ready(id: int) -> void:
	if players_ready.has(id):
		players_ready.erase(id)
	else:
		players_ready.push_back(id)
	
	# lil bit janky
	players_ready.sort()
	var connected_players = multiplayer.get_peers()
	connected_players.sort()
	
	Debug.log(str(players_ready))
	if players_ready == connected_players:
		Debug.log("everyone ready!")
		on_all_ready.emit(load("res://src/map/docks/map.tscn"))
		
func player_unready(id: int) -> void:
	players_ready.erase(id)
