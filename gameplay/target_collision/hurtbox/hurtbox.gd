class_name Hurtbox extends Area2D


@export var actor: Entity:
	get:
		if not actor:
			actor = get_parent()
		return actor
