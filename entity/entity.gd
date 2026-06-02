class_name Entity extends CharacterBody2D


@export var health: float = 100.0
@export var attack_damage: float = 2.0
@export var projectile_spawnpoint_from_origin: float = 200.0


@onready var sprite: Sprite2D = $Sprite


func take_damage(amount: float) -> void:
	print(name + " got hit (%.2f -> %.2f)" % [health, health - amount])
	health -= amount
	if health <= 0:
		womp_womp()


# Death function
func womp_womp() -> void:
	print(name + " died")
	set_physics_process(false)
	set_process(false)
	sprite.self_modulate.a = 0.3
