class_name PlayerManager extends Node

@onready var map_manager: MapManager = %MapManager
@onready var player_scene: PackedScene = preload("res://src/player/player.tscn")
@onready var players: Node = %Players

func setup() -> void:
	GameManager.make_random_player_it.connect(make_random_player_it)
	GameManager.player_is_it.connect(make_player_it)
	GameManager.game_reset_if_required.connect(reset_game)
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	spawn_connected_players()

# TODO: should client add dummy players for others connected?
func add_player(id: int) -> void:
	var player: CharacterBody3D = player_scene.instantiate()
	player.name = str(id)
	player.position.x = randi_range(-5, 5)
	player.position.z = randi_range(-5, 5)
	players.add_child(player, true)

func remove_player(id: int) -> void:
	var player = players.get_node(str(id))
	if player:
		players.remove_child(player)
		player.queue_free()
	if players.get_children().is_empty():
		Debug.log("stopping game...")
		map_manager.change_map(load("res://src/map/lobby/map.tscn"))
	elif is_nobody_it():
		GameManager.pick_someone_to_be_it()

func spawn_connected_players() -> void:
	for id: int in multiplayer.get_peers():
		# don't spawn a server player
		if id != 1:
			add_player(id)

func remove_all_players() -> void:
	for player: Player in players.get_children():
		players.remove_child(player)
		player.queue_free()

# game stuff

func make_random_player_it() -> void:
	if players.get_children().is_empty():
		return
	var player = players.get_children().pick_random()
	if player is Player:
		player.is_it = true

func make_player_it(id: int) -> void:
	var player = players.get_node(str(id))
	if player is Player:
		player.is_it = true

func is_nobody_it() -> bool:
	return players.get_children().all(func(p: Player): return !p.is_it)

func is_everyone_it() -> bool:
	return players.get_children().all(func(p: Player): return p.is_it)

func reset_game() -> void:
	if is_everyone_it():
		for player: Player in players.get_children():
			player.is_it = false
		GameManager.pick_someone_to_be_it()
