class_name BulletProjectile extends RangedProjectile


func apply_hit_effect(creature : Creature) -> void:
	queue_free() # TEMPORARY
