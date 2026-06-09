class_name Projectile extends Entity


var direction: Vector2 = Vector2.ZERO
var movement_speed: float = 0.0

var fired_by: Entity = null


func _physics_process(delta: float) -> void:
	velocity = direction * movement_speed
	move_and_slide()


func apply_hit_effect(entity: Entity) -> void:
	pass


func free() -> void:
	queue_free()


func disable() -> void:
	set_physics_process(false)


func wait(time: float) -> void:
	await get_tree().create_timer(time).timeout
