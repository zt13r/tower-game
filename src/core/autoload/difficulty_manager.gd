extends Node
## Difficulty setup.


# Rewards and enemy stats are increased
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


func set_difficulty(new: Difficulty) -> void:
	current_difficulty = new
	_set_difficulty_multiplier()


func get_difficulty_multiplier() -> float:
	return difficulty_multiplier
