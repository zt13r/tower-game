class_name SkillTwoJoystick extends Joystick


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _ready() -> void:
	super()
	cooldown_timer.wait_time = player.skill_two_recharge_time


func _control_joystick(pos: Vector2) -> void:
	super(pos)
	# Joystick is clicked only, not dragged
	if stick.position == Vector2.ZERO:
		dir = _get_auto_aim_direction()
	Game.skill_two_joystick_direction = dir.normalized()


func _release_joystick() -> void:
	Game.last_skill_two_joystick_direction = Game.skill_two_joystick_direction

	if not dragging:
		return

	Game.skill_two_joystick_released = true

	await super()

	Game.skill_two_joystick_direction = Vector2.ZERO
	Game.skill_two_joystick_released = false


func _get_auto_aim_direction() -> Vector2:
	return player.get_closest_enemy().global_position - player.global_position
