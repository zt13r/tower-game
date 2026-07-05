class_name BulletProjectile
extends RangedProjectile


func apply_hit_effect(target : LifeEntity) -> void:
	queue_free() # TEMPORARY
