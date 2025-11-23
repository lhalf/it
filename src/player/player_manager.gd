class_name PlayerManager extends Node

@onready var player_scene: PackedScene = preload("res://src/player/player.tscn")
@onready var players: Node = %Players

func setup() -> void:
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
	if players.has_node(str(id)):
		var player: CharacterBody3D = players.get_node(str(id))
		players.remove_child(player)
		player.queue_free()

func spawn_connected_players() -> void:
	for id: int in multiplayer.get_peers():
		# don't spawn a server player
		if id != 1:
			add_player(id)

func remove_all_players() -> void:
	for player: CharacterBody3D in players.get_children():
		players.remove_child(player)
		player.queue_free()
