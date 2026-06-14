class_name MoveJoystick extends Joystick


func _ready() -> void:
	super()


func _control_joystick(pos: Vector2) -> void:
	super(pos)
	JoystickManager.move_joystick_direction = dir.normalized()


func _release_joystick() -> void:
	super()
	JoystickManager.move_joystick_direction = Vector2.ZERO
