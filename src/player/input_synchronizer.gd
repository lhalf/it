extends MultiplayerSynchronizer

@onready var shotgun: Shotgun = %Shotgun

@export var direction := Vector2.ZERO
@export var space_pressed := false

func _ready() -> void:
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())

func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "forward", "backward")
	space_pressed = Input.is_action_pressed("jump")

# TODO: move this
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_left"):
		shotgun.shoot_left.rpc()
	if event.is_action_pressed("shoot_right"):
		shotgun.shoot_right.rpc()
