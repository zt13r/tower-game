class_name FireAbility extends Ability


@export_group("Scenes")
@export var basic_attack_scene: PackedScene = preload("uid://d0g7ynfi6atpe")
@export var skill_one_scene: PackedScene = null
@export var skill_two_scene: PackedScene = null
@export_group("Projectile Speed")
@export var basic_attack_projectile_speed: float = 500.0


func basic_attack() -> void:
	super()
	if actor.basic_attacked:
		return
	var attack := basic_attack_scene.instantiate() as FireProjectile
	attack.direction = Game.last_basic_attack_joystick_position
	attack.movement_speed = basic_attack_projectile_speed
	attack.global_position = actor.global_position
	projectiles_node_group.add_child(attack)


func skill_one() -> void:
	if actor.skill_oned:
		return


func skill_two() -> void:
	if actor.skill_twod:
		return
