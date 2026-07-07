class_name Level
extends Node2D


@onready var player_spawn : Marker2D = %PlayerSpawn
@onready var level_camera : LevelCamera = %LevelCamera


func get_player_spawn() -> Vector2:
	return player_spawn.global_position


func get_player_camera() -> LevelCamera:
	return level_camera
