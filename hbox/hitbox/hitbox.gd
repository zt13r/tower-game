class_name Hitbox extends Area2D


@export var actor: Entity:
	get:
		if not actor:
			actor = get_parent()
		return actor


func _ready() -> void:
	if not is_connected("body_entered", _on_hitbox_pinged):
		connect("body_entered", _on_hitbox_pinged)


func _on_hitbox_pinged(hurtbox: Hurtbox) -> void:
	var target := hurtbox.actor as Entity

	# Player can't damage themselves with their own projectiles
	if actor is Projectile and actor.fired_by == hurtbox.actor:
		return

	var damage: float = 0.0
	if actor is Creature:
		damage = actor.attack_damage
	elif actor is Projectile:
		damage = actor.damage

	target.take_damage(damage)

	if actor is Projectile:
		actor.apply_hit_effect(target)
