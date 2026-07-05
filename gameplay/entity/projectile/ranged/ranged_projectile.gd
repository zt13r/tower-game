class_name RangedProjectile
extends Projectile


func _physics_process(_delta : float) -> void:
	velocity = direction * movement_speed
	move_and_slide()
