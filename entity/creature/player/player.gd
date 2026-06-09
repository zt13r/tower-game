class_name Player extends Creature


const MAX_ENEMY_DISTANCE: float = 1500.0 # idk
const HITMARKER_RADIUS: float = 100.0


@export_group("Kit")
@export var ability: Ability = null
@export var weapon: Weapon = null
@export_group("Dash")
@export var dash_speed: float = 1500.0
@export var dash_distance: float = 500.0
@export var dash_duration: float = 0.5 # in seconds
@export var dash_cooldown: float = 0.5 # in seconds


enum State {
	DASHING,
	IDLE,
	MOVING,
	START_DASH,
	USE_BASIC_ATTACK,
	USE_SKILL_ONE,
	USE_SKILL_TWO,
	USING_BASIC_ATTACK,
	USING_SKILL_ONE,
	USING_SKILL_TWO
}

var current_state: State = State.IDLE

var current_kit: Kit:
	get:
		if not current_kit:
			current_kit = ability
		return current_kit

var state_names: Array[String] = [
	"DASHING",
	"IDLE",
	"MOVING",
	"START_DASH",
	"USE_BASIC_ATTACK",
	"USE_SKILL_ONE",
	"USE_SKILL_TWO",
	"USING_BASIC_ATTACK",
	"USING_SKILL_ONE",
	"USING_SKILL_TWO"
]

var move_dir: Vector2 = Vector2.ZERO

var dashing: bool = false
var can_dash: bool = true
var dash_distance_remaining: float = 0.0
var dash_time_remaining: float = 0.0
var dash_recharge_time: float = 0.0
var dash_target_point: Vector2 = Vector2.ZERO
var dashed: bool = false

var can_basic_attack: bool = true
var basic_attack_recharge_time: float = 0.0
var use_basic_attack: bool = false
var using_basic_attack: bool = false

var can_skill_one: bool = true
var skill_one_recharge_time: float = 0.0
var use_skill_one: bool = false
var using_skill_one: bool = false

var can_skill_two: bool = true
var skill_two_recharge_time: float = 0.0
var use_skill_two: bool = false
var using_skill_two: bool = false


@onready var dash_cooldown_timer: Timer = $Timers/Cooldown/DashCooldownTimer
@onready var basic_attack_cooldown_timer: Timer = $Timers/Cooldown/BasicAttackCooldownTimer
@onready var skill_one_cooldown_timer: Timer = $Timers/Cooldown/SkillOneCooldownTimer
@onready var skill_two_cooldown_timer: Timer = $Timers/Cooldown/SkillTwoCooldownTimer
@onready var hitmarker: Marker2D = $Hitmarker

@onready var state_label: Label = $StateLabel


func _ready() -> void:
	super()
	_setup()


func _process(delta: float) -> void:
	move_dir = Game.move_joystick_position
	dashed = Game.dash_joystick_released
	use_basic_attack = Game.basic_attack_joystick_released
	use_skill_one = Game.skill_one_joystick_released
	use_skill_two = Game.skill_two_joystick_released


func _physics_process(delta: float) -> void:
	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving(move_dir)
		State.START_DASH: _process_start_dash()
		State.DASHING: _process_dashing(delta)
		State.USE_BASIC_ATTACK: _process_use_basic_attack()
		State.USING_BASIC_ATTACK: _process_using_basic_attack()
		State.USE_SKILL_ONE: _process_use_skill_one()
		State.USING_SKILL_ONE: _process_using_skill_one()
		State.USE_SKILL_TWO: _process_use_skill_two()
		State.USING_SKILL_TWO: _process_using_skill_two()

	# Transition states
	if dashing:
		current_state = State.DASHING
	elif can_dash and dashed:
		current_state = State.START_DASH
	elif using_skill_two:
		current_state = State.USING_SKILL_TWO
	elif using_skill_one:
		current_state = State.USING_SKILL_ONE
	elif using_basic_attack:
		current_state = State.USING_BASIC_ATTACK
	elif can_skill_two and use_skill_two:
		current_state = State.USE_SKILL_TWO
	elif can_skill_one and use_skill_one:
		current_state = State.USE_SKILL_ONE
	elif can_basic_attack and use_basic_attack:
		current_state = State.USE_BASIC_ATTACK
	elif move_dir != Vector2.ZERO:
		current_state = State.MOVING
	else:
		current_state = State.IDLE

	# Hitmarker position
	if Game.basic_attack_joystick_position != Vector2.ZERO:
		_set_hitmarker_position(Game.basic_attack_joystick_position)
	elif Game.skill_one_joystick_position != Vector2.ZERO:
		_set_hitmarker_position(Game.skill_one_joystick_position)
	elif Game.skill_two_joystick_position != Vector2.ZERO:
		_set_hitmarker_position(Game.skill_two_joystick_position)

	# Debug state
	state_label.text = state_names.get(current_state)

	move_and_slide()


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


func _process_use_basic_attack() -> void:
	if current_kit is Ability:
		ability.basic_attack()
	elif current_kit is Weapon:
		weapon.basic_attack()
	using_basic_attack = true
	can_basic_attack = false


func _process_using_basic_attack() -> void:
	await wait(current_kit.basic_attack_duration)
	using_basic_attack = false
	basic_attack_cooldown_timer.start()


func _process_use_skill_one() -> void:
	if current_kit is Ability:
		ability.skill_one()
	elif current_kit is Weapon:
		weapon.skill_one()
	using_skill_one = true


func _process_using_skill_one() -> void:
	await wait(current_kit.skill_one_duration)
	using_skill_one = false


func _process_use_skill_two() -> void:
	if current_kit is Ability:
		ability.skill_two()
	elif current_kit is Weapon:
		weapon.skill_two()
	using_skill_two = true


func _process_using_skill_two() -> void:
	await wait(current_kit.skill_two_duration)
	using_skill_two = false


func _setup() -> void:
	super()

	# Dash
	if not dash_cooldown_timer.is_connected("timeout", _on_dash_cooldown_timeout):
		dash_cooldown_timer.connect("timeout", _on_dash_cooldown_timeout)
	dash_recharge_time = dash_cooldown
	dash_cooldown_timer.wait_time = dash_recharge_time

	# Basic attack
	if not basic_attack_cooldown_timer.is_connected("timeout", _on_basic_attack_cooldown_timer_timeout):
		basic_attack_cooldown_timer.connect("timeout", _on_basic_attack_cooldown_timer_timeout)
	basic_attack_recharge_time = current_kit.basic_attack_cooldown
	basic_attack_cooldown_timer.wait_time = basic_attack_recharge_time

	# Skill one
	if not skill_one_cooldown_timer.is_connected("timeout", _on_skill_one_cooldown_timer_timeout):
		skill_one_cooldown_timer.connect("timeout", _on_skill_one_cooldown_timer_timeout)
	skill_one_recharge_time = current_kit.skill_one_cooldown
	skill_one_cooldown_timer.wait_time = skill_one_recharge_time

	# Skill two
	if not skill_two_cooldown_timer.is_connected("timeout", _on_skill_two_cooldown_timer_timeout):
		skill_one_cooldown_timer.connect("timeout", _on_skill_two_cooldown_timer_timeout)
	skill_two_recharge_time = current_kit.skill_two_cooldown
	skill_two_cooldown_timer.wait_time = skill_two_recharge_time


func _set_hitmarker_position(pos: Vector2) -> void:
	hitmarker.position = pos * HITMARKER_RADIUS


func get_closest_enemy() -> Enemy:
	var enemies := get_tree().get_nodes_in_group("Enemy")
	var closest_enemy: Enemy = enemies[0]
	for enemy in enemies:
		if get_distance(enemy) > MAX_ENEMY_DISTANCE:
			continue
		if get_distance(enemy) < get_distance(closest_enemy):
			closest_enemy = enemy
	return closest_enemy


func get_distance(enemy: Enemy) -> float:
	return (enemy.global_position - global_position).length()


func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_basic_attack_cooldown_timer_timeout() -> void:
	can_basic_attack = true


func _on_skill_one_cooldown_timer_timeout() -> void:
	can_skill_one = true


func _on_skill_two_cooldown_timer_timeout() -> void:
	can_skill_two = true
