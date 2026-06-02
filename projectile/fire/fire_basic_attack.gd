class_name FireProjectile extends Projectile


const PERCENT_TO_DECIMAL: float = 0.1


@export_group("Parameters")
@export var reduced_heal_multiplier: float = 0.7
@export var burn_duration: float = 4.0
@export var burn_interval: float = 1.0
@export var burn_damage: float = 2.0 # % of entity health
@export_group("Meta Variables")
@export var burn_meta: String = "burn"
@export var heal_meta: String = "reduced_heal"


var burn_time: float = 0.0


func apply_hit_effect(entity: Entity) -> void:
	if entity.has_meta(burn_meta):
		return
	if entity.has_meta(heal_meta):
		return

	_burn_effect(entity)
	_reduced_heal(entity)


func _burn_effect(entity: Entity) -> void:
	entity.set_meta(burn_meta, burn_duration)
	burn_time = entity.get_meta(burn_meta)
	while burn_time > 0.0:
		entity.take_damage(entity.health * (burn_damage * PERCENT_TO_DECIMAL))
		burn_time -= burn_interval
		print(name, " burning")
		await wait(burn_interval)


func _reduced_heal(entity: Entity) -> void:
	pass
