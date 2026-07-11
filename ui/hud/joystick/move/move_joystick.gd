class_name MoveJoystick
extends Joystick


func _ready() -> void:
	super()


func _control_joystick(pos : Vector2) -> void:
	super(pos)
	JoystickHandler.move_direction = dir.normalized()


func _release_joystick() -> void:
	super()
	JoystickHandler.move_direction = Vector2.ZERO
