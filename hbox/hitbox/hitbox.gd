class_name Hitbox extends Area2D


@export var actor: Entity:
	get:
		if not actor:
			actor = get_parent()
		return actor


func _ready() -> void:
	if not is_connected("body_entered", _on_hitbox_pinged):
		connect("body_entered", _on_hitbox_pinged)
	monitorable = true
	monitoring = true

func _on_hitbox_pinged(hurtbox: Hurtbox) -> void:
	var target := hurtbox.actor as Entity

	# No friendly fire
	if actor is Projectile and actor.fired_by == hurtbox.actor:
		return

	var damage := actor.attack_damage

	target.take_damage(damage)

	if actor is Projectile:
		actor.apply_hit_effect(target)
