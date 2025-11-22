extends Node

const PORT: int = 8080
const ADDRESS: String = "it.lhalf.uk"

var peer := ENetMultiplayerPeer.new()

func _ready() -> void:
	get_tree().paused = true
	if "--server" in OS.get_cmdline_args():
		_create_server()
	else:
		_join_server()

func _create_server() -> void:
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	Debug.log("server created")
	get_tree().paused = false
	%PlayerManager.setup()
	%MapManager.change_map.call_deferred(load("res://src/map/1/map.tscn"))

func _join_server() -> void:
	var address: String = "localhost" if  "--localhost" in OS.get_cmdline_args() else ADDRESS;
	if peer.create_client(address, PORT) != OK:
		return
	multiplayer.multiplayer_peer = peer
	if not multiplayer.server_disconnected.is_connected(_on_disconnect):
		multiplayer.server_disconnected.connect(_on_disconnect)
	await multiplayer.connected_to_server
	Debug.log("joined server")
	get_tree().paused = false

func _on_disconnect() -> void:
	Debug.log("left server")
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	%PlayerManager.remove_all_players()
	%MapManager.remove_map()
