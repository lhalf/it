extends Node

const PORT: int = 8443
const ADDRESS: String = "wss://it.lhalf.uk/server/"

var peer := WebSocketMultiplayerPeer.new()

func _ready() -> void:
	get_tree().paused = true
	if "--server" in OS.get_cmdline_args():
		# TODO: remove
		get_tree().root.mode = Window.MODE_MINIMIZED
		_create_server()
	else:
		_join_server()

func _create_server() -> void:
	var err = peer.create_server(PORT)
	if err != OK:
		Debug.log("failed to create server")
		return
	multiplayer.multiplayer_peer = peer
	Debug.log("server created")
	get_tree().paused = false
	%PlayerManager.setup()
	%MapManager.change_map.call_deferred(load("res://src/map/lobby/map.tscn"))

func _join_server() -> void:
	Debug.log("joining server...")
	var address: String = "localhost" if  "--localhost" in OS.get_cmdline_args() else ADDRESS;
	if peer.create_client(address) != OK:
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
