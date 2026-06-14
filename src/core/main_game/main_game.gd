class_name MainGame
extends Node
## Main game processing.


const PLAYER_SCENE_UID : String = "uid://by8d1ms5l2esh"


var player : Player = null

var _current_level : BaseLevel = null


# Systems nodes
@onready var wait_timer : Timer = %WaitTimer


# Game World root nodes
@onready var level_root   : Node2D = %LevelRoot
@onready var entity_root  : Node2D = %EntityRoot
@onready var effects_root : Node2D = %EffectsRoot

# UI root nodes
@onready var hud_root        : Control = %HudRoot
@onready var pause_root      : Control = %PauseRoot
@onready var transition_root : Control = %TransitionRoot


func _ready() -> void:
	_init_player()
	_setup_wait_timer()


## Instantiates the player and adds it to the entity layer.
func _init_player() -> void:
	var player_scene : PackedScene = ResourceLoader.load(PLAYER_SCENE_UID) as PackedScene
	if player_scene == null:
		push_error("Could not load player scene: " + PLAYER_SCENE_UID)
		return

	player = player_scene.instantiate() as Player
	if player == null:
		push_error("Loaded player scene does not extend Player or DNE: " + PLAYER_SCENE_UID)
		return

	entity_root.add_child(player)


## Called for loading a level scene.
func load_level(level_scene : String) -> void:
	_deferred_load_level.call_deferred(level_scene)


func _deferred_load_level(level_scene_uid : String) -> void:
	if _current_level != null:
		_current_level.queue_free()
		_current_level = null

	# Allow the old level to finish freeing before loading the new level
	await get_tree().process_frame

	var new_level_packed : PackedScene =\
		ResourceLoader.load(level_scene_uid, "PackedScene") as PackedScene
	if new_level_packed == null:
		push_error("Could not load new level as PackedScene: " + level_scene_uid)
		return

	_current_level = new_level_packed.instantiate() as BaseLevel
	if _current_level == null:
		push_error("Loaded level scene does not extend BaseLevel or DNE: " + level_scene_uid)
		return
		# FUTURE: add main menu fallback scene

	level_root.add_child(_current_level)

	# Allow level to fully process before doing anything with the level
	await get_tree().process_frame
	_place_player_at_level_spawn()
	_setup_level_camera()


func _place_player_at_level_spawn() -> void:
	if player == null:
		push_error("Cannot place player in level because it is null.")
		return

	if _current_level == null:
		push_error("Cannot place player in level because level is null.")
		return

	player.global_position = _current_level.get_player_spawn()


func _setup_level_camera() -> void:
	if player == null:
		push_error("Cannot setup level camera because player is null.")
		return

	if _current_level == null:
		push_error("Cannot setup level camera because level is null.")
		return

	var level_camera : Camera2D = _current_level.get_player_camera()
	if level_camera == null:
		push_error("Cannot setup level camera because level camera is null.")
		return

	# Some cool camera magic happens here idk


func _setup_wait_timer() -> void:
	GameManager.wait_timer = wait_timer
