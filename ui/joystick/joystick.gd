class_name Joystick extends Control


# 1.0 = stick can't get out of base
# 2.0 = stick can get out of base halfway
const JOYSTICK_MARGIN_CLEARANCE = 2.0


@export var has_cooldown: bool = false
@export var click_area: float = 256.0


var bounds: PackedVector2Array:
	get:
		if not bounds:
			bounds = PackedVector2Array([
				Vector2(-click_area, -click_area), # Top left
				Vector2(click_area, click_area), # Bottom right
			])
		return bounds

var max_radius: float = 0.0
var stick_radius: float = 0.0
var base_radius: float = 0.0

var default_pos: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.ZERO
var dragging: bool = false

var touch_index: int = 0

# Used only if "has_cooldown" is true
var in_cooldown: bool = false


@onready var base: Sprite2D = $Base
@onready var stick: Sprite2D = $Stick
@onready var cooldown_timer: Timer = $CooldownTimer


func _ready() -> void:
	_setup()


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
	stick.global_position = pos
	dir = stick.global_position - global_position

	# Locks joystick (small circle in the middle) to the joybase (big circle)
	# According to the value of max_radius
	if stick.position.length() > max_radius:
		stick.position = dir.normalized() * max_radius
		stick.position = dir.normalized() * max_radius


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
		Vector2.ZERO,
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


func _setup() -> void:
	default_pos = global_position
	base_radius = base.texture.get_width() / 2.0
	stick_radius = stick.texture.get_width() / 2.0
	max_radius = (base_radius - stick_radius) * JOYSTICK_MARGIN_CLEARANCE


func _on_cooldown_timer_timeout() -> void:
	in_cooldown = false


# Thank you random Reddit guy
func to_local(global: Vector2) -> Vector2:
	return (get_global_transform().affine_inverse()) * global


# Thank you random Reddit guy
func to_global(local: Vector2) -> Vector2:
	return (get_global_transform()) * local
