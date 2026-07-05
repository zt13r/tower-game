class_name LifeEntity
extends Entity
## Superclass for all entities that can move and take damage.


@export var max_health : float = 100.0
@export var move_speed : float = 700.0


var health : float = 0.0
var dead : bool = false


## Initial stat and signal assignment.
func _setup() -> void:
	health = max_health


## Damage function. The Creature takes amount damage.
func take_damage(amount : float) -> void:
	if dead:
		return

	print(name, " took %.2f damage (new health: %.2f)" % [amount, health - amount])
	health -= amount
	if health <= 0:
		die()


## Death function.
func die() -> void:
	dead = true
	print(name, " died")
	set_physics_process(false)
	set_process(false)
