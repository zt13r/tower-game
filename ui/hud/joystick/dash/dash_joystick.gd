class_name DashJoystick
extends Joystick


@export var player : Player :
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _ready() -> void:
	super()
	if player == null:
		push_error("Player reference is null.")
		set_process_input(false)
		return
	cooldown_timer.wait_time = player.dash_recharge_time


func _control_joystick(pos : Vector2) -> void:
	super(pos)
	Game.dash_joystick_direction = dir.normalized()


func _release_joystick() -> void:
	if not dragging:
		return

	# Will not dash if the joystick is only pressed, and not directed/aimed
	if stick.position == Vector2.ZERO:
		return

	Game.dash_joystick_released = true

	await super()

	Game.dash_joystick_direction = Vector2.ZERO
	Game.dash_joystick_released = false
