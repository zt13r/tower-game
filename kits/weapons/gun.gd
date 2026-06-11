class_name GunWeapon extends Weapon


@export_group("Scenes")
@export var basic_attack_scene: PackedScene = null
@export var skill_one_scene: PackedScene = null
@export var skill_two_scene: PackedScene = null
@export_group("Basic Attack")
@export var bullet_basic_attack_speed: float = 750.0
@export var bullet_basic_attack_damage: float = 10.0
@export_group("Skill One")
@export var bullet_skill_one_speed: float = 950.0
@export var bullet_skill_one_damage: float = 12.0
@export_group("Skill Two")
@export var bullet_skill_two_speed: float = 1150.0
@export var bullet_skill_two_damage: float = 15.0


func basic_attack() -> void:
	super()
	if not basic_attack_scene:
		print("%s has no basic attack scene" % name)
		return

	var attack := basic_attack_scene.instantiate() as BulletProjectile
	attack.damage = basic_attack_damage
	attack.movement_speed = bullet_basic_attack_speed
	attack.direction = Game.last_basic_attack_joystick_direction
	attack.global_position = actor.hitmarker.global_position
	attack.fired_by = actor

	player_projectiles.add_child(attack)


func skill_one() -> void:
	super()


func skill_two() -> void:
	super()
