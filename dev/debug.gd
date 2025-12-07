extends Node

@export var debug_mode := false

@onready var logs: RichTextLabel = %Logs

func _ready() -> void:
	if "--dbg" in OS.get_cmdline_args():
		debug_mode = true

func log(message: String) -> void:
	print(message)
	logs.text += Time.get_time_string_from_system() + ": " + message + "\n"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_delete"):
		get_tree().quit()
