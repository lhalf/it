extends MultiplayerSynchronizer

@onready var weapon: Weapon = %Weapon
@onready var hand_left: HandLeft = %HandLeft

@export var direction := Vector2.ZERO
@export var space_pressed := false

@onready var ui: UI = %UI

func _ready() -> void:
	var is_authority = get_multiplayer_authority() == multiplayer.get_unique_id()
	set_process(is_authority)
	set_process_input(is_authority)

func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "forward", "backward")
	space_pressed = Input.is_action_pressed("jump")

func _input(event: InputEvent) -> void:
	if ui.menu.visible:
		return
	
	if (Input.mouse_mode != Input.MOUSE_MODE_CAPTURED) and event is InputEventMouseButton: 
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("shoot"):
		weapon.shoot()
	
	if event.is_action_pressed("tag"):
		hand_left.tag.rpc()
