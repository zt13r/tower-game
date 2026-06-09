class_name Entity extends CharacterBody2D


@export var max_health: float = 100.0
@export var attack_damage: float = 2.0


var health: float = 0.0

var dead: bool = false


@onready var sprite: AnimatedSprite2D = $Sprite


func _ready() -> void:
	_setup()


func _play_animation(anim: String) -> void:
	sprite.play(anim)


func _setup() -> void:
	health = max_health


func take_damage(amount: float) -> void:
	if dead:
		return

	print(name, " got hit (%.2f -> %.2f)" % [health, health - amount])
	health -= amount
	if health <= 0:
		womp_womp()


# Death function
func womp_womp() -> void:
	dead = true
	print(name, " died")
	set_physics_process(false)
	set_process(false)
	sprite.self_modulate.a = 0.3
