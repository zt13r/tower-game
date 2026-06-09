class_name Entity extends CharacterBody2D


func free() -> void:
	queue_free()


func disable_physics() -> void:
	set_physics_process(false)


func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
