class_name FireAbility extends Ability


@export_group("Scenes")
@export var basic_attack_scene: PackedScene = preload("uid://dvn1gxa4n3xde")
@export var skill_one_scene: PackedScene = preload("uid://dvn1gxa4n3xde")
@export var skill_two_scene: PackedScene = null
@export_group("Projectile Speed")
@export var basic_attack_speed: float = 750.0
@export var skill_one_speed: float = 1500.0


func basic_attack() -> void:
	super()
	if not basic_attack_scene:
		print("%s has no basic attack scene" % name)
		return

	var attack := basic_attack_scene.instantiate() as FireProjectile
	attack.damage = basic_attack_damage
	attack.movement_speed = basic_attack_speed
	attack.direction = Game.last_basic_attack_joystick_direction
	attack.global_position = actor.hitmarker.global_position
	attack.fired_by = actor

	player_projectiles.add_child(attack)


func skill_one() -> void:
	super()
	if not skill_one_scene:
		print("%s has no skill one scene" % name)
		return

	var attack := basic_attack_scene.instantiate() as FireProjectile
	attack.damage = skill_one_damage
	attack.direction = Game.last_skill_one_joystick_direction
	attack.movement_speed = skill_one_speed
	attack.global_position = actor.hitmarker.global_position
	attack.scale *= 1.5
	attack.fired_by = actor

	player_projectiles.add_child(attack)


func skill_two() -> void:
	super()
