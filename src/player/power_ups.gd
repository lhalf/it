class_name PowerUps extends Node

@onready var movement: Movement = %Movement

@onready var speed_timer: Timer = %SpeedTimer
@onready var speed_sound: AudioStreamPlayer3D = %SpeedSound

func _ready() -> void:
	Signals.power_up_activated.connect(_on_power_up)

func _on_power_up(id: int, type: PowerUp.Type) -> void:
	# apply on the server for the person who touched the power up
	if get_parent().name != str(id):
		return
	match type:
		PowerUp.Type.SPEED:
			_apply_speed(id)

func _apply_speed(id: int) -> void:
	speed_timer.start()
	_speed_effects.rpc_id(id)
	movement.movement_values.max_speed += 10

@rpc("authority", "call_remote", "reliable")
func _speed_effects() -> void:
	speed_sound.play()

func _on_speed_timer_timeout() -> void:
	movement.movement_values.max_speed = movement.movement_values.DEFAULT_SPEED
