class_name Main
extends Node


const PLAYER_SCENE_UID : String = "uid://by8d1ms5l2esh"


var player : Player = null

var current_level : Level = null


@onready var level_root : Node2D = %LevelRoot
@onready var entity_root : Node2D = %EntityRoot

@onready var hud_root : Control = %HudRoot
@onready var pause_root : Control = %PauseRoot
@onready var menu_root : Control = %MenuRoot
@onready var transition_root : Control = %TransitionRoot
@onready var debug_root : Control = %DebugRoot


func _ready() -> void:
	_init_ui()


func _load_level(level_scene : String) -> void:
	_deferred_load_level.call_deferred(level_scene)


func _deferred_load_level(level_scene_uid : String) -> void:
	if current_level != null:
		current_level.queue_free()
		current_level = null

	await get_tree().process_frame

	var new_level_scene : PackedScene = load(level_scene_uid) as PackedScene
	if new_level_scene == null:
		push_error("Could not load new level as PackedScene: " + level_scene_uid)
		return

	current_level = new_level_scene.instantiate() as Level
	if current_level == null:
		push_error("Loaded level scene does not extend BaseLevel or DNE: " + level_scene_uid)
		# Add main menu fallback scene probably
		return

	level_root.add_child(current_level)

	await get_tree().process_frame

	_load_player()


func _load_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return

	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend Player or DNE: " + PLAYER_SCENE_UID)
		return

	entity_root.add_child(player)

	await get_tree().process_frame

	# Place player at the level's designated spawn
	player.global_position = current_level.get_player_spawn()

	# Assign the player as the target of the level's designated camera
	var level_camera : Camera2D = current_level.get_player_camera()
	if level_camera == null:
		push_error("Cannot set level camera because level camera is null.")
		return
	level_camera.target = player


func _init_ui() -> void:
	hud_root.hide()
	pause_root.hide()
	transition_root.hide()

	menu_root.show()
	debug_root.show()


func _on_play_pressed() -> void:
	var level : int = Game.get_current_level()
	var level_uid : String = Game.get_level_uid(level)
	_load_level(level_uid)
