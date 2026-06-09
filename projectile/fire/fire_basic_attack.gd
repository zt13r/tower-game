class_name FireProjectile extends Projectile


const PERCENT_TO_DECIMAL: float = 0.01


@export_group("Parameters")
@export var antiheal_multiplier: float = 0.7
@export var burn_duration: float = 4.0
@export var burn_interval: float = 1.0
@export var burn_damage: float = 2.0 # % of entity health
@export_group("Meta Variables")
@export var burn_meta: String = "burn"
@export var antiheal_meta: String = "antiheal"


var burn_time: float = 0.0

var burn_finished: bool = false
var antiheal_finished: bool = false


func _process(delta: float) -> void:
	if burn_finished and antiheal_finished:
		free()


func apply_hit_effect(entity: Entity) -> void:
	if entity.has_meta(burn_meta):
		return
	if entity.has_meta(antiheal_meta):
		return

	_apply_burn(entity)
	_apply_antiheal(entity)

	disable()


func _apply_burn(entity: Entity) -> void:
	entity.set_meta(burn_meta, burn_duration)
	burn_time = entity.get_meta(burn_meta)
	while burn_time > 0.0:
		await wait(burn_interval)
		var damage := entity.max_health * (burn_damage * PERCENT_TO_DECIMAL)
		entity.take_damage(damage)
		burn_time -= burn_interval
	burn_finished = true


func _apply_antiheal(entity: Entity) -> void:
	pass
