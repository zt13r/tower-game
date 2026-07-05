@abstract
class_name Kit
extends Node


@export var actor : Player: # PLACEHOLDER?
	get:
		if not actor:
			actor = get_tree().get_first_node_in_group("Player")
		return actor
@export var entity_layer : Node2D:
	get:
		if not entity_layer:
			entity_layer = get_tree().get_first_node_in_group("EntityRoot")
		return entity_layer

@export_group("Damage")
@export var basic_attack_damage : float = 2.0
@export var skill_one_damage    : float = 7.0
@export var skill_two_damage    : float = 12.0

# In seconds
@export_group("Cooldown")
@export var basic_attack_cooldown : float = 0.2
@export var skill_one_cooldown    : float = 3.0
@export var skill_two_cooldown    : float = 7.0

@export_group("Duration")
@export var basic_attack_duration : float = 0.1
@export var skill_one_duration    : float = 0.5
@export var skill_two_duration    : float = 0.5


var basic_attack_scene_uid : String = "uid://btpkhaot7gad"
var skill_one_scene_uid : String = ""
var skill_two_scene_uid : String = ""

var basic_attack_scene : PackedScene = null
var skill_one_scene : PackedScene = null
var skill_two_scene : PackedScene = null


func _ready() -> void:
	_load_scenes()


func _load_scenes() -> void:
	_deferred_load_scenes.call_deferred()


func _deferred_load_scenes() -> void:
	basic_attack_scene = ResourceLoader.load(basic_attack_scene_uid)
	skill_one_scene = ResourceLoader.load(skill_one_scene_uid)
	skill_two_scene = ResourceLoader.load(skill_two_scene_uid)


@abstract func basic_attack() -> void


@abstract func skill_one() -> void


@abstract func skill_two() -> void
