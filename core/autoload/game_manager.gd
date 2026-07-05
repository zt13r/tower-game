extends Node
## Autoload for miscellaneous stuff that does not fall under other autoloads.


# Rewards and enemy stats are increased accordingly.
enum Difficulty {
	CLASSIC,    # 1x
	HARD,       # 2x
	EXTREME,    # 3x
}


var current_difficulty : Difficulty = Difficulty.CLASSIC
var difficulty_multiplier : float = 1.0

var wait_timer : Timer = null


## Changes the difficulty multiplier.
func _set_difficulty_multiplier() -> void:
	match current_difficulty:
		Difficulty.CLASSIC: difficulty_multiplier = 1.0
		Difficulty.HARD: difficulty_multiplier = 2.0
		Difficulty.EXTREME: difficulty_multiplier = 3.0


## Changes game difficulty.
func set_difficulty(new: Difficulty) -> void:
	current_difficulty = new as Difficulty
	_set_difficulty_multiplier()


## Returns current difficulty multiplier.
func get_difficulty_multiplier() -> float:
	return difficulty_multiplier



## Global wait function.
## WARNING: Calling this function while the timer is still running
## will override the previous call. Make some way around this, soon. Idk.
func wait(time: float) -> void:
	wait_timer.one_shot = true
	wait_timer.wait_time = time
	wait_timer.start()
	await wait_timer.timeout
