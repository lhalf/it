extends Node # GameManager

# tag hand collisions are on layer 10

const SETUP_TIME: int = 1

signal on_all_ready(PackedScene)
signal make_random_player_it
signal player_is_it(int)
signal game_reset_if_required

var players_ready: PackedInt32Array = []

func _ready() -> void:
	multiplayer.peer_disconnected.connect(player_unready)

func toggle_ready(id: int) -> void:
	if players_ready.has(id):
		players_ready.erase(id)
	else:
		players_ready.push_back(id)

	if _is_everyone_ready():
		_start_game()
		
func player_unready(id: int) -> void:
	players_ready.erase(id)

func _is_everyone_ready() -> bool:
	players_ready.sort()
	var connected_players = multiplayer.get_peers()
	connected_players.sort()
	return players_ready == connected_players

func _start_game() -> void:
	Debug.log("starting game...")
	on_all_ready.emit(load("res://src/map/docks/map.tscn"))
	pick_someone_to_be_it()

func pick_someone_to_be_it() -> void:
	await get_tree().create_timer(SETUP_TIME).timeout
	make_random_player_it.emit()

@rpc("any_peer", "call_remote", "reliable")
func make_player_it(id: int) -> void:
	player_is_it.emit(id)

@rpc("any_peer", "call_remote", "reliable")
func does_game_need_reset() -> void:
	await get_tree().create_timer(SETUP_TIME).timeout
	game_reset_if_required.emit()
