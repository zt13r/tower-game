class_name Creature extends Entity


@export var max_health: float = 100.0
@export var move_speed: float = 700.0


var health: float = 0.0

var dead: bool = false


func _ready() -> void:
	_setup()


func _setup() -> void:
	health = max_health


func take_damage(amount: float) -> void:
	if dead:
		return

	print(name, " took %.2f damage (new health: %.2f)" % [amount, health - amount])
	health -= amount
	if health <= 0:
		womp_womp()


# Death function
func womp_womp() -> void:
	dead = true
	print(name, " died")
	set_physics_process(false)
	set_process(false)
