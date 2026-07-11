class_name SkillOneJoystick
extends Joystick


func _ready() -> void:
	super()
	if player == null:
		push_error("Player reference is null.")
		set_process_input(false)
		return
	cooldown_timer.wait_time = player.skill_one_cooldown


func _control_joystick(pos : Vector2) -> void:
	super(pos)

	# Auto aim direction to the closest enemy
	# if joystick is pressed and not directed/aimed
	if stick.position == Vector2.ZERO:
		dir = _get_auto_aim_direction()


func _release_joystick() -> void:
	if not dragging:
		return

	JoystickHandler.skill_one_released.emit(dir)

	await super()


func _get_auto_aim_direction() -> Vector2:
	return player.get_closest_enemy().global_position - player.global_position
