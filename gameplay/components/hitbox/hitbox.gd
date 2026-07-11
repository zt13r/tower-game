class_name Hitbox
extends Area2D


@export var actor : Projectile :
	get:
		if not actor:
			# Assuming parent is Pivot, and Pivot's parent is Projectile
			actor = get_parent().get_parent() as Projectile
		return actor


func _ready() -> void:
	if not is_connected("area_entered", _on_hitbox_pinged):
		connect("area_entered", _on_hitbox_pinged)


func _on_hitbox_pinged(hurtbox : Hurtbox) -> void:
	var target := hurtbox.actor as Entity

	# Actors can't damage themselves with their own projectiles
	if actor.fired_by == hurtbox.actor:
		return

	var damage : float = actor.damage

	target.take_damage(damage)
	actor.apply_hit_effect(target)
