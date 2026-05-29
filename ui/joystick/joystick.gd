class_name Joystick extends Control


const STICK_CLAMP: float = 100.0

@export var has_cooldown: bool = false
@export var click_area: float = 256.0


var bounds: PackedVector2Array = PackedVector2Array([
	Vector2(-click_area, -click_area), # Top left
	Vector2(click_area, click_area), # Bottom right
])

var default_pos: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO
var dragging: bool = false

# Used only if "has_cooldown" is true
var in_cooldown: bool = false

var touch_index: int = 0


@onready var base: CenterContainer = $Base
@onready var stick: CenterContainer = $Stick
@onready var cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	default_pos = global_position


func _input(event: InputEvent) -> void:
	if in_cooldown:
		return

	if event is InputEventScreenTouch:
		if event.is_pressed():
			if _in_click_area(event.position):
				dragging = true
				touch_index = event.index
				_reposition_joystick(event.position, event.is_pressed())
				_control_joystick(event.position)
		elif touch_index == event.index:
			_reposition_joystick(event.position, event.is_pressed())
			_release_joystick()
			dragging = false
	if event is InputEventScreenDrag:
		if dragging and touch_index == event.index:
			_control_joystick(event.position)


func _control_joystick(pos: Vector2) -> void:
	stick.global_position = pos - (stick.size / 2.0)
	dir = stick.global_position - global_position

	# Visual
	stick.global_position = stick.global_position.clamp(
		to_global(Vector2(-STICK_CLAMP, -STICK_CLAMP)) - (stick.size / 2.0),
		to_global(Vector2(STICK_CLAMP, STICK_CLAMP)) - (stick.size / 2.0)
	)


func _reposition_joystick(pos: Vector2, pressed: bool) -> void:
	if pressed:
		global_position = pos
	else:
		global_position = default_pos


func _release_joystick() -> void:
	# Cool animation
	var tween := get_tree().create_tween()
	tween.tween_property(
		stick,
		"position",
		-(stick.size / 2),
		0.1
	).set_ease(
		Tween.EASE_OUT).set_trans(
			Tween.TRANS_EXPO)

	if has_cooldown and not in_cooldown:
		await _cooldown()


func _cooldown():
	in_cooldown = true
	cooldown_timer.start()
	await cooldown_timer.timeout


func _in_click_area(pos: Vector2) -> bool:
	pos = to_local(pos)
	return (
		(pos.x >= bounds[0].x && pos.y >= bounds[0].y) &&
		(pos.x <= bounds[1].x && pos.y <= bounds[1].y)
	)


func _on_cooldown_timer_timeout() -> void:
	in_cooldown = false


func to_local(global: Vector2) -> Vector2:
	return (get_global_transform().affine_inverse()) * global


func to_global(local: Vector2) -> Vector2:
	return (get_global_transform()) * local
