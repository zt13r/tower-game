class_name Player extends Entity


@export_subgroup("Movement")
@export var move_speed: float = 700.0

@export_subgroup("Dash")
@export var dash_speed: float = 1500.0
@export var dash_distance: float = 500.0
@export var dash_duration: float = 0.5 # in seconds
@export var dash_cooldown: float = 0.5 # in seconds

@export_subgroup("Attack")
@export var basic_attack_cooldown: float = 0.2

# This is very unstable
@export_subgroup("Node References")
@export var kit_slot_1: KitSlot:
	get:
		if not kit_slot_1:
			kit_slot_1 = get_tree().get_nodes_in_group("KitSlots")[0]
		return kit_slot_1
@export var kit_slot_2: KitSlot:
	get:
		if not kit_slot_2:
			kit_slot_2 = get_tree().get_nodes_in_group("KitSlots")[1]
		return kit_slot_2

enum State {
	IDLE,
	MOVING,
	START_DASH,
	DASHING,
	BASIC_ATTACK
}

var current_state: State = State.IDLE

enum Kit {
	ABILITY,
	WEAPON,
}

var current_kit: Kit = Kit.ABILITY

var dashing: bool = false
var can_dash: bool = true
var dash_distance_remaining: float = 0.0
var dash_time_remaining: float = 0.0
var dash_recharge_time: float = 0.0
var dash_target_point: Vector2 = Vector2.ZERO

var can_basic_attack: bool = true
var basic_attack_recharge_time: float = 0.0


@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var basic_attack_cooldown_timer: Timer = $Timers/BasicAttackCooldownTimer

@onready var state_label: Label = $StateLabel
@onready var kit_slot_label: Label = $"../UI/KitSlots/Label"


func _ready() -> void:
	_setup()


func _physics_process(delta: float) -> void:
	var move_dir := Game.move_joystick_position
	var dashed := Game.dash_joystick_released
	var basic_attacked := Game.basic_attack_joystick_released

	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving(move_dir)
		State.START_DASH: _process_start_dash()
		State.DASHING: _process_dashing(delta)
		State.BASIC_ATTACK: _process_basic_attack()

	# Transition states
	if dashing:
		current_state = State.DASHING
	elif can_dash and dashed:
		current_state = State.START_DASH
	elif can_basic_attack and basic_attacked:
		current_state = State.BASIC_ATTACK
	elif move_dir != Vector2.ZERO:
		current_state = State.MOVING
	else:
		current_state = State.IDLE

	# Debug state
	state_label.text = _print_state(current_state)

	move_and_slide()


func _print_state(state: int) -> String:
	match state:
		State.IDLE: return "idle"
		State.MOVING: return "moving"
		State.START_DASH: return "start_dash" 
		State.DASHING: return "dashing"
		State.BASIC_ATTACK: return "basic_attack"
	return "man idk"


func _process_idle() -> void:
	if (velocity != Vector2.ZERO):
		velocity = Vector2.ZERO


func _process_moving(dir: Vector2) -> void:
	velocity = dir * move_speed


func _process_start_dash() -> void:
	can_dash = false
	dash_distance_remaining = dash_distance
	dash_time_remaining = dash_duration

	var dash_dir = Game.dash_joystick_position
	dash_target_point = dash_dir * dash_distance

	dashing = true


func _process_dashing(delta: float) -> void:
	dash_distance_remaining -= get_position_delta().length()
	dash_time_remaining -= delta

	# Dash end condition
	if dash_distance_remaining <= 0.0 or dash_time_remaining <= 0.0:
		dash_cooldown_timer.start()
		dashing = false
		return

	# Dash movement
	velocity = dash_target_point.normalized() * dash_speed


func _process_basic_attack() -> void:
	print("basc atkack")


func _setup() -> void:
	# Dash
	if not dash_cooldown_timer.is_connected(
		"timeout", 
		_on_dash_cooldown_timeout
	):
		dash_cooldown_timer.connect("timeout", _on_dash_cooldown_timeout)
	dash_recharge_time = dash_cooldown
	dash_cooldown_timer.wait_time = dash_recharge_time

	# Basic attack
	if not basic_attack_cooldown_timer.is_connected(
		"timeout",
		_on_basic_attack_cooldown_timer_timeout
	):
		basic_attack_cooldown_timer.connect("timeout", _on_basic_attack_cooldown_timer_timeout)
	basic_attack_recharge_time = basic_attack_cooldown
	basic_attack_cooldown_timer.wait_time = basic_attack_recharge_time


func change_kit(new: Kit) -> void:
	current_kit = new
	_update_kit(current_kit)


func _update_kit(new: Kit) -> void:
	# Placeholder
	match new:
		Kit.ABILITY:
			kit_slot_1.sprite.self_modulate = Color.BURLYWOOD
			kit_slot_2.sprite.self_modulate = Color.BURLYWOOD
			kit_slot_label.text = "ability"
		Kit.WEAPON:
			kit_slot_1.sprite.self_modulate = Color.DARK_KHAKI
			kit_slot_2.sprite.self_modulate = Color.DARK_KHAKI
			kit_slot_label.text = "weapon"
	kit_slot_1.sprite.self_modulate.a = 0.5
	kit_slot_2.sprite.self_modulate.a = 0.5


func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_basic_attack_cooldown_timer_timeout() -> void:
	can_basic_attack = true
