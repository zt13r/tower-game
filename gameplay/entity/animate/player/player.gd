class_name Player
extends LifeEntity


## Player states.
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

const MAX_ENEMY_DISTANCE : float = 1500.0 # idk
const HITMARKER_RADIUS   : float = 100.0


@export_group("Kit")
@export var ability: Ability: # PLACEHOLDER
	get:
		var abilities := get_tree().get_first_node_in_group("Abilities").get_children()
		if not ability:
			ability = abilities[0]
		return ability
@export var weapon: Weapon: # PLACEHOLDER
	get:
		var weapons := get_tree().get_first_node_in_group("Weapons").get_children()
		if not weapon:
			weapon = weapons[0]
		return weapon
@export_group("Dash")
@export var dash_speed    : float = 1500.0
@export var dash_distance : float = 500.0
@export var dash_duration : float = 0.5 # In seconds
@export var dash_cooldown : float = 0.5 # In seconds


var current_state : State = State.IDLE

var current_kit : Kit = null

## Debug state names.
var state_names : Array[String] = [
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

## Movement parameters.
var move_dir : Vector2 = Vector2.ZERO

## Dash parameters.
var can_dash                : bool = true
var dashing                 : bool = false
var dashed                  : bool = false
var dash_distance_remaining : float = 0.0
var dash_time_remaining     : float = 0.0
var dash_recharge_time      : float = 0.0
var dash_target_point       : Vector2 = Vector2.ZERO

## Basic attack parameters.
var can_basic_attack           : bool = true
var use_basic_attack           : bool = false
var using_basic_attack         : bool = false
var basic_attack_recharge_time : float = 0.0

## Skill one parameters.
var can_skill_one           : bool = true
var use_skill_one           : bool = false
var using_skill_one         : bool = false
var skill_one_recharge_time : float = 0.0

## Skill two parameters.
var can_skill_two           : bool = true
var use_skill_two           : bool = false
var using_skill_two         : bool = false
var skill_two_recharge_time : float = 0.0


## Cooldown timers.
@onready var dash_cooldown_timer         : Timer = %DashCooldownTimer
@onready var basic_attack_cooldown_timer : Timer = %BasicAttackCooldownTimer
@onready var skill_one_cooldown_timer    : Timer = %SkillOneCooldownTimer
@onready var skill_two_cooldown_timer    : Timer = %SkillTwoCooldownTimer

@onready var hitmarker : Marker2D = %Hitmarker

## Debug nodes.
@onready var state_label : Label = %StateLabel


func _ready() -> void:
	_setup()


func _draw() -> void:
	draw_line(
		Vector2.ZERO, # line from
		to_local(hitmarker.global_position), # line to
		Color.WHITE, # line color
		5.0, # width
	)


func _process(_delta : float) -> void:
	move_dir = Game.move_joystick_direction
	dashed = Game.dash_joystick_released
	use_basic_attack = Game.basic_attack_joystick_released
	use_skill_one = Game.skill_one_joystick_released
	use_skill_two = Game.skill_two_joystick_released


func _physics_process(delta : float) -> void:
	# Process current_state
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

	# Transition to state
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
	if Game.basic_attack_joystick_direction != Vector2.ZERO:
		_set_hitmarker_position(Game.basic_attack_joystick_direction)
	elif Game.skill_one_joystick_direction != Vector2.ZERO:
		_set_hitmarker_position(Game.skill_one_joystick_direction)
	elif Game.skill_two_joystick_direction != Vector2.ZERO:
		_set_hitmarker_position(Game.skill_two_joystick_direction)

	# Debug state
	state_label.text = state_names.get(current_state)

	move_and_slide()


#################################################################
###                          STATES                           ###
#################################################################


func _process_idle() -> void:
	if (velocity != Vector2.ZERO):
		velocity = Vector2.ZERO


func _process_moving(dir: Vector2) -> void:
	velocity = dir * move_speed


func _process_start_dash() -> void:
	can_dash = false
	dash_distance_remaining = dash_distance
	dash_time_remaining = dash_duration

	var dash_dir = Game.dash_joystick_direction
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
	can_basic_attack = false
	current_kit.basic_attack()
	using_basic_attack = true


func _process_using_basic_attack() -> void:
	await Game.wait(current_kit.basic_attack_duration)
	using_basic_attack = false
	basic_attack_cooldown_timer.start()


func _process_use_skill_one() -> void:
	can_skill_one = false
	current_kit.skill_one()
	using_skill_one = true


func _process_using_skill_one() -> void:
	await Game.wait(current_kit.skill_one_duration)
	using_skill_one = false
	skill_one_cooldown_timer.start()


func _process_use_skill_two() -> void:
	can_skill_two = false
	current_kit.skill_two()
	using_skill_two = true


func _process_using_skill_two() -> void:
	await Game.wait(current_kit.skill_two_duration)
	using_skill_two = false
	skill_two_cooldown_timer.start()


#################################################################
###                         PRIVATE                           ###
#################################################################


func _setup() -> void:
	health = max_health
	current_kit = ability

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


## PLACEHOLDER: Places the hitmarker at pos direction
## and HITMARKER_RADIUS distance. Calls queue_redraw() to
## draw debug lines written in draw().
func _set_hitmarker_position(pos : Vector2) -> void:
	hitmarker.position = pos * HITMARKER_RADIUS
	queue_redraw()


#################################################################
###                          PUBLIC                           ###
#################################################################


func get_closest_enemy() -> Enemy:
	var enemies := get_tree().get_nodes_in_group("Enemy")
	var closest_enemy: Enemy = enemies[0]
	for enemy in enemies:
		if get_distance(enemy) > MAX_ENEMY_DISTANCE:
			continue
		if get_distance(enemy) < get_distance(closest_enemy):
			closest_enemy = enemy
	return closest_enemy


func get_distance(enemy : Enemy) -> float:
	return (enemy.global_position - global_position).length()


## PLACEHOLDER
func swap_kit() -> void:
	@warning_ignore("incompatible_ternary")
	current_kit = weapon if current_kit == ability else ability


#################################################################
###                         SIGNALS                           ###
#################################################################


func _on_dash_cooldown_timeout() -> void:
	can_dash = true


func _on_basic_attack_cooldown_timer_timeout() -> void:
	can_basic_attack = true


func _on_skill_one_cooldown_timer_timeout() -> void:
	can_skill_one = true


func _on_skill_two_cooldown_timer_timeout() -> void:
	can_skill_two = true
