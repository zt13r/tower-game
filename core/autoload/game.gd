extends Node


# to-do:
# - if party has multiple player same ability/weapon,
#   reduce effectiveness of stats to balance


#################################################################
###                         JOYSTICK                          ###
#################################################################


var move_joystick_direction : Vector2 = Vector2.ZERO
var dash_joystick_direction : Vector2 = Vector2.ZERO
var basic_attack_joystick_direction : Vector2 = Vector2.ZERO
var skill_one_joystick_direction : Vector2 = Vector2.ZERO
var skill_two_joystick_direction : Vector2 = Vector2.ZERO

var last_basic_attack_joystick_direction : Vector2 = Vector2.ZERO
var last_skill_one_joystick_direction : Vector2 = Vector2.ZERO
var last_skill_two_joystick_direction : Vector2 = Vector2.ZERO

var dash_joystick_released : bool = false
var basic_attack_joystick_released : bool = false
var skill_one_joystick_released : bool = false
var skill_two_joystick_released : bool = false


#################################################################
###                        DIFFICULTY                         ###
#################################################################


# Rewards and enemy stats are increased accordingly.
enum Difficulty {
	CLASSIC,    # 1x
	HARD,       # 2x
	EXTREME,    # 3x
}


var current_difficulty : Difficulty = Difficulty.CLASSIC
var difficulty_multiplier : float = 1.0


func _set_difficulty_multiplier() -> void:
	match current_difficulty:
		Difficulty.CLASSIC: difficulty_multiplier = 1.0
		Difficulty.HARD: difficulty_multiplier = 2.0
		Difficulty.EXTREME: difficulty_multiplier = 3.0


func set_difficulty(new:  Difficulty) -> void:
	current_difficulty = new as Difficulty
	_set_difficulty_multiplier()


func get_difficulty_multiplier() -> float:
	return difficulty_multiplier


#################################################################
###                          LEVEL                            ###
#################################################################


# Story = 10 floors
# 10th Story = floors 91-100
var level_uids : Array[String] = [
	# 1st Story
	"uid://bnbseaejnh1g",
]


var current_level : int = 1


func get_level_uid(level_number : int) -> String:
	return level_uids.get(level_number - 1)
	# 1 because array index stuff surely you know


func get_current_level() -> int:
	return current_level


func next_level() -> void:
	current_level += 1
