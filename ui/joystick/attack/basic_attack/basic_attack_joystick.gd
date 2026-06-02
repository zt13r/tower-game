class_name BasicAttackJoystick extends Joystick


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _ready() -> void:
	super()
	cooldown_timer.wait_time = player.basic_attack_recharge_time


func _control_joystick(pos: Vector2) -> void:
	super(pos)
	# Joystick is clicked only, not dragged
	#if stick.position == Vector2.ZERO:
	if stick.position == Vector2(-64, -64):
		dir = _get_auto_aim_direction()
	Game.basic_attack_joystick_position = dir.normalized()


func _release_joystick() -> void:
	Game.last_basic_attack_joystick_position = Game.basic_attack_joystick_position

	if not dragging:
		return
	if stick.position == Vector2.ZERO:
		return

	Game.basic_attack_joystick_released = true

	await super()

	Game.basic_attack_joystick_position = Vector2.ZERO
	Game.basic_attack_joystick_released = false


func _get_auto_aim_direction() -> Vector2:
	return player.get_closest_enemy().global_position - player.global_position
