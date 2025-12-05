extends Node

@onready var logs: RichTextLabel = %Logs

func log(message: String) -> void:
	print(message)
	logs.text += Time.get_time_string_from_system() + ": " + message + "\n"

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
