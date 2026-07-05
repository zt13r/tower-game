class_name FireAbility
extends Ability


@export_group("Projectile Speed")
@export var basic_attack_speed : float = 750.0
@export var skill_one_speed : float = 1500.0


var basic_attack_scene_uid : String = "uid://dvn1gxa4n3xde"
var skill_one_scene_uid : String = "uid://dvn1gxa4n3xde"
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


func basic_attack() -> void:
	if basic_attack_scene == null:
		push_error("FireAbility basic_attack_scene is null.")
		return

	var attack := basic_attack_scene.instantiate() as FireProjectile
	attack.damage = basic_attack_damage
	attack.movement_speed = basic_attack_speed
	attack.direction = JoystickManager.last_basic_attack_joystick_direction
	attack.global_position = actor.hitmarker.global_position
	attack.fired_by = actor

	entity_layer.add_child(attack)


func skill_one() -> void:
	if skill_one_scene == null:
		push_error("FireAbility skill_one_scene is null.")
		return

	var attack := basic_attack_scene.instantiate() as FireProjectile
	attack.damage = skill_one_damage
	attack.direction = JoystickManager.last_skill_one_joystick_direction
	attack.movement_speed = skill_one_speed
	attack.global_position = actor.hitmarker.global_position
	attack.scale *= 1.5
	attack.fired_by = actor

	entity_layer.add_child(attack)


func skill_two() -> void:
	pass
