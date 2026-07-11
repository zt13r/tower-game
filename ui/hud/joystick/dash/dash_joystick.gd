class_name DashJoystick
extends Joystick


func _ready() -> void:
	super()
	if player == null:
		push_error("Player reference is null.")
		set_process_input(false)
		return
	cooldown_timer.wait_time = player.dash_cooldown


func _control_joystick(pos : Vector2) -> void:
	super(pos)


func _release_joystick() -> void:
	if not dragging:
		return

	# Will not dash if the joystick is only pressed, and not directed/aimed
	if stick.position == Vector2.ZERO:
		return

	JoystickHandler.dash_released.emit(dir)

	await super()
