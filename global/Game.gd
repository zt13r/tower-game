extends Node


# Rewards and enemy stats are increased
enum Difficulty {
	CLASSIC,    # 1x
	HARD,       # 2x
	EXTREME,    # 3x
}

var current_difficulty: Difficulty = Difficulty.CLASSIC
var difficulty_multiplier: float = 0.0


var move_joystick_position: Vector2 = Vector2.ZERO
var dash_joystick_position: Vector2 = Vector2.ZERO
var basic_attack_joystick_position: Vector2 = Vector2.ZERO
var skill_one_joystick_position: Vector2 = Vector2.ZERO
var skill_two_joystick_position: Vector2 = Vector2.ZERO

var dash_joystick_released: bool = false
var basic_attack_joystick_released: bool = false
var skill_one_joystick_released: bool = false
var skill_two_joystick_released: bool = false


func set_difficulty(new: Difficulty) -> void:
	current_difficulty = new
	_set_difficulty_multiplier()


func _set_difficulty_multiplier() -> void:
	match current_difficulty:
		Difficulty.CLASSIC: difficulty_multiplier = 1.0
		Difficulty.HARD: difficulty_multiplier = 2.0
		Difficulty.EXTREME: difficulty_multiplier = 3.0
