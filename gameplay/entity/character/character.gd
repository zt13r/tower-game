@abstract
class_name Character
extends Entity
## Superclass for all entities that can move and take damage.


@export var max_health : float = 100.0
@export var move_speed : float = 700.0


var health : float = 0.0
var dead : bool = false


func _init_entity() -> void:
	super()
	health = max_health


func take_damage(amount : float) -> void:
	if dead:
		return

	print(name, " took %.2f damage (new health: %.2f)" % [amount, health - amount])
	health -= amount
	if health <= 0:
		die()


func die() -> void:
	dead = true
	print(name, " died")
	set_physics_process(false)
	set_process(false)
