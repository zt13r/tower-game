class_name Player
extends Character


@export var ability : Ability = null
@export var weapon : Weapon = null


@export_group("Cooldown") ## In seconds
@export var dash_cooldown : float = 1.0
@export var primary_cooldown : float = 0.5
@export var skill_one_cooldown : float = 2.0
@export var skill_two_cooldown : float = 3.0
@export var skill_three_cooldown : float = 4.0


@onready var move_joystick : MoveJoystick = %MoveJoystick
@onready var dash_joystick : DashJoystick = %DashJoystick
@onready var primary_joystick : PrimaryJoystick = %BasicAttackJoystick
@onready var skill_one_joystick : SkillOneJoystick = %SkillOneJoystick
@onready var skill_two_joystick : SkillTwoJoystick = %SkillTwoJoystick
@onready var skill_three_joystick : SkillThreeJoystick = %SkillThreeJoystick

@onready var state_machine : StateMachine = $StateMachine


#################################################################
###                         PRIVATE                           ###
#################################################################


func _init_entity() -> void:
	super()
	if not is_in_group("Player"):
		add_to_group("Player")

	if ability != null:
		ability.player = self
	if weapon != null:
		weapon.player = self


#################################################################
###                          PUBLIC                           ###
#################################################################


func get_ability() -> Ability:
	return ability


func get_weapon() -> Weapon:
	return weapon


func get_closest_enemy() -> Enemy:
	var enemy : Enemy = null
	return enemy
