class_name GunWeapon
extends Weapon


@export_group("Basic Attack")
@export var bullet_basic_attack_speed: float = 750.0
@export var bullet_basic_attack_damage: float = 10.0

@export_group("Skill One")
@export var bullet_skill_one_speed  : float = 950.0
@export var bullet_skill_one_damage : float = 12.0

@export_group("Skill Two")
@export var bullet_skill_two_speed  : float = 1150.0
@export var bullet_skill_two_damage : float = 15.0


var basic_attack_scene_uid : String = "uid://btpkhaot7gad"
var skill_one_scene_uid    : String = ""
var skill_two_scene_uid    : String = ""

var basic_attack_scene : PackedScene = null
var skill_one_scene    : PackedScene = null
var skill_two_scene    : PackedScene = null


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
		push_error("GunWeapon basic_attack_scene is null.")
		return

	var attack := basic_attack_scene.instantiate() as BulletProjectile
	attack.damage = basic_attack_damage
	attack.movement_speed = bullet_basic_attack_speed
	attack.direction = JoystickManager.last_basic_attack_joystick_direction
	attack.global_position = actor.hitmarker.global_position
	attack.fired_by = actor

	entity_layer.add_child(attack)


func skill_one() -> void:
	pass


func skill_two() -> void:
	pass
