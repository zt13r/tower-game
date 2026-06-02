class_name Player extends Entity


const MAX_ENEMY_DISTANCE: float = 1500.0 # idk


@export_group("Movement")
@export var move_speed: float = 700.0

@export_subgroup("Dash")
@export var dash_speed: float = 1500.0
@export var dash_distance: float = 500.0
@export var dash_duration: float = 0.5 # in seconds
@export var dash_cooldown: float = 0.5 # in seconds

@export_subgroup("Kit")
@export var ability: Ability = null
@export var weapon: Weapon = null


enum State {
	IDLE,
	MOVING,
	START_DASH,
	DASHING,
	BASIC_ATTACK,
	SKILL_ONE,
	SKILL_TWO,
}

var current_state: State = State.IDLE

var current_kit: Kit:
	get:
		if not current_kit:
			current_kit = ability
		return current_kit

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
var basic_attacked: bool = false

var can_skill_one: bool = true
var skill_one_recharge_time: float = 0.0
var skill_oned: bool = false

var can_skill_two: bool = true
var skill_two_recharge_time: float = 0.0
var skill_twod: bool = false


@onready var dash_cooldown_timer: Timer = $Timers/DashCooldownTimer
@onready var basic_attack_cooldown_timer: Timer = $Timers/BasicAttackCooldownTimer
@onready var skill_one_cooldown_timer: Timer = $Timers/SkillOneCooldownTimer
@onready var skill_two_cooldown_timer: Timer = $Timers/SkillTwoCooldownTimer

@onready var state_label: Label = $StateLabel
@onready var kit_slot_label: Label = $"../UI/KitSlots/Label"


func _ready() -> void:
	_setup()


func _process(delta: float) -> void:
	move_dir = Game.move_joystick_position
	dashed = Game.dash_joystick_released
	basic_attacked = Game.basic_attack_joystick_released
	skill_oned = Game.skill_one_joystick_released
	skill_twod = Game.skill_two_joystick_released


func _physics_process(delta: float) -> void:
	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving(move_dir)
		State.START_DASH: _process_start_dash()
		State.DASHING: _process_dashing(delta)
		State.BASIC_ATTACK: _process_basic_attack()
		State.SKILL_ONE: _process_skill_one()
		State.SKILL_TWO: _process_skill_two()

	# Transition states
	if dashing:
		current_state = State.DASHING
	elif can_dash and dashed:
		current_state = State.START_DASH
	elif can_skill_two and skill_twod:
		current_state = State.SKILL_TWO
	elif can_skill_one and skill_oned:
		current_state = State.SKILL_ONE
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
		State.SKILL_ONE: return "skill_one"
		State.SKILL_TWO: return "skill_two"
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
	if current_kit is Ability:
		ability.basic_attack()
	elif current_kit is Weapon:
		weapon.basic_attack()


func _process_skill_one() -> void:
	if current_kit is Ability:
		ability.skill_one()
	elif current_kit is Weapon:
		weapon.skill_one()


func _process_skill_two() -> void:
	if current_kit is Ability:
		ability.skill_two()
	elif current_kit is Weapon:
		weapon.skill_two()


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
	basic_attack_recharge_time = current_kit.basic_attack_cooldown
	basic_attack_cooldown_timer.wait_time = basic_attack_recharge_time

	# Skill one
	if not skill_one_cooldown_timer.is_connected(
		"timeout",
		_on_skill_one_cooldown_timer_timeout
	):
		skill_one_cooldown_timer.connect("timeout", _on_skill_one_cooldown_timer_timeout)
	skill_one_recharge_time = current_kit.skill_one_cooldown
	skill_one_cooldown_timer.wait_time = skill_one_recharge_time

	# Skill two
	if not skill_two_cooldown_timer.is_connected(
		"timeout",
		_on_skill_two_cooldown_timer_timeout
	):
		skill_one_cooldown_timer.connect("timeout", _on_skill_two_cooldown_timer_timeout)
	skill_two_recharge_time = current_kit.skill_two_cooldown
	skill_two_cooldown_timer.wait_time = skill_two_recharge_time


#func change_kit(new: CurrentKit) -> void:
	#current_kit = new
	#_update_kit(current_kit)
#
#
#func _update_kit(new: CurrentKit) -> void:
	## Placeholder
	#match new:
		#CurrentKit.ABILITY:
			#kit_slot_1.sprite.self_modulate = Color.BURLYWOOD
			#kit_slot_2.sprite.self_modulate = Color.BURLYWOOD
			#kit_slot_label.text = "ability"
		#CurrentKit.WEAPON:
			#kit_slot_1.sprite.self_modulate = Color.DARK_KHAKI
			#kit_slot_2.sprite.self_modulate = Color.DARK_KHAKI
			#kit_slot_label.text = "weapon"
	#kit_slot_1.sprite.self_modulate.a = 0.5
	#kit_slot_2.sprite.self_modulate.a = 0.5


func get_closest_enemy() -> Enemy:
	var enemies := get_tree().get_nodes_in_group("Enemy")
	var closest_enemy: Enemy = enemies[0]
	for enemy in enemies:
		if get_distance(enemy) > MAX_ENEMY_DISTANCE:
			return
		if get_distance(enemy) < get_distance(closest_enemy):
			closest_enemy = enemy
	print("Closest enemy distance: ", get_distance(closest_enemy))
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
