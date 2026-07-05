class_name FireProjectile
extends RangedProjectile


@export_group("Parameters")
@export var antiheal_multiplier : float = 0.7
@export var burn_duration : float = 4.0 # Ideally divisible by burn_interval
@export var burn_interval : float = 1.0
@export var burn_percent : float = 2.0 # % of entity health

@export_group("Meta Variables")
@export var burn_meta : String = "burn"
@export var antiheal_meta : String = "antiheal"


var burn_time : float = 0.0

var burn_finished : bool = false
var antiheal_finished : bool = false


func _process(delta : float) -> void:
	if burn_finished and antiheal_finished:
		free()


func apply_hit_effect(target : LifeEntity) -> void:
	set_physics_process(false)

	if target.has_meta(burn_meta):
		return
	if target.has_meta(antiheal_meta):
		return

	_apply_burn(target)
	_apply_antiheal(target)


## Applies burn DoT effect to hit LifeEntity.
func _apply_burn(target : LifeEntity) -> void:
	target.set_meta(burn_meta, burn_duration)
	burn_time = target.get_meta(burn_meta)

	while burn_time > 0.0:
		await GameManager.wait(burn_interval)
		var percent_damage : float =\
			DamageUtil.get_percent_damage(target.max_health, burn_percent)
		print("Burn effect: ")
		target.take_damage(percent_damage)
		burn_time -= burn_interval

	target.remove_meta(burn_meta)
	burn_finished = true


func _apply_antiheal(target : LifeEntity) -> void:
	pass
