class_name TagStatus extends Node

@onready var hit_sound: AudioStreamPlayer = %HitSound
@onready var tag_cooldown: Timer = %TagCooldown
@onready var tag_area: Area3D = %TagArea

@onready var it_label: Label = %ItLabel
@onready var name_tag: Label3D = %NameTag

func _on_tag_area_body_entered(body: Node3D) -> void:
	if body is Player:
		GameManager.make_player_it.rpc_id(1, int(body.name))
		tag_area.set_deferred("monitoring", false)
		tag_cooldown.start()
		hit_sound.play()

func _on_tag_cooldown_timeout() -> void:
	if get_parent().is_it:
		tag_area.monitoring = true

func it_effects_everyone(is_it: bool) -> void:
	if is_it:
		name_tag.modulate = Color.RED
	else:
		name_tag.modulate = Color.WHITE

func it_effects_client(is_it: bool) -> void:
	if is_it:
		tag_area.monitoring = true
		it_label.show()
		GameManager.does_game_need_reset.rpc_id(1)
	else:
		tag_area.monitoring = false
		it_label.hide()
