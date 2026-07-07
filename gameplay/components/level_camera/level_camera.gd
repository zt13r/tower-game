class_name LevelCamera
extends Camera2D


var target : Node2D = null


func _physics_process(delta: float) -> void:
	if target:
		global_position = target.global_position
