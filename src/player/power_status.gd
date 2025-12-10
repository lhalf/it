class_name PowerStatus extends Node

@onready var movement: Movement = %Movement
@onready var shotgun: Shotgun = %Shotgun

@onready var speed_timer: Timer = %SpeedTimer
@onready var speed_sound: AudioStreamPlayer3D = %SpeedSound

func _ready() -> void:
	Signals.pad_activated.connect(_on_pad)
	Signals.power_up_activated.connect(_on_power_up)

# PADS

func _on_pad(id: int, type: Pad.Type) -> void:
	# apply on the server for the person who touched the power up
	if get_parent().name != str(id):
		return
	match type:
		Pad.Type.JUMP:
			_apply_jump(id)

# POWER UPS

func _on_power_up(id: int, type: PowerUp.Type) -> void:
	# apply on the server for the person who touched the power up
	if get_parent().name != str(id):
		return
	match type:
		PowerUp.Type.SPEED:
			_apply_speed(id)
		PowerUp.Type.RELOAD:
			shotgun.reload()

# effects

func _apply_jump(_id: int) -> void:
	movement.apply_impulse(Vector3.UP * Pad.JUMP_POWER)

func _apply_speed(id: int) -> void:
	speed_timer.start()
	_speed_effects.rpc_id(id)
	movement.movement_values.max_speed += 10

@rpc("authority", "call_remote", "reliable")
func _speed_effects() -> void:
	speed_sound.play()

func _on_speed_timer_timeout() -> void:
	movement.movement_values.max_speed = movement.movement_values.DEFAULT_SPEED
