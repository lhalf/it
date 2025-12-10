@tool
class_name Pad extends Area3D

@onready var mesh: MeshInstance3D = %Mesh
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

enum Type { NULL, JUMP, RELOAD }

var colors: Dictionary = {
	Type.NULL: Color.WHITE,
	Type.JUMP: Color.PURPLE,
	Type.RELOAD: Color.SADDLE_BROWN
}

var sounds: Dictionary = {
	Type.NULL: null,
	Type.JUMP: preload("res://src/pad/assets/jump.wav"),
	Type.RELOAD: null
}

const JUMP_POWER: int = 20

@export var type: Type = Type.NULL:
	set(new_type):
		type = new_type
		_update_color(colors.get(type))
		

func _update_color(color: Color) -> void:
	if mesh: # some weirdness idk
		mesh.mesh.material.albedo_color = color

func _ready() -> void:
	_update_sound(sounds.get(type))

func _update_sound(sound: Resource) -> void:
	audio_stream_player.stream = sound

func _on_area_entered(area: Area3D) -> void:
	if area is PlayerArea:
		Signals.rpc_id(1, "alert_pad", type)
		audio_stream_player.play()
