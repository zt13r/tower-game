extends Node
## Autoload for miscellaneous stuff that does not fall under other autoloads.


var wait_timer : Timer = null


## Global wait function.
func wait(time: float) -> void:
	wait_timer.one_shot = true
	wait_timer.wait_time = time
	wait_timer.start()
	await wait_timer.timeout
