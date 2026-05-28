class_name DashJoystick extends Joystick


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _ready() -> void:
	super()
	cooldown_timer.wait_time = player.dash_recharge_time


func _control_joystick(pos: Vector2) -> void:
	super(pos)
	Game.dash_joystick_position = dir.normalized()


func _release_joystick() -> void:
	if not dragging:
		return
	# Will not dash if only pressed and not directed
	if stick.position == Vector2.ZERO:
		return

	Game.dash_joystick_released = true

	await super()

	Game.dash_joystick_position = Vector2.ZERO
	Game.dash_joystick_released = false
