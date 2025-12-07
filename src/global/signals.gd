extends Node

signal power_up_activated(id: int, type: PowerUp.Type)

@rpc("any_peer", "call_remote", "reliable")
func alert_power_up(type: PowerUp.Type) -> void:
	power_up_activated.emit(multiplayer.get_remote_sender_id(), type)
