class_name Hurtbox
extends Area2D


@export var actor : Entity :
	get:
		if not actor:
			# Assuming parent is Pivot, and Pivot's parent is Entity
			actor = get_parent().get_parent()
		return actor
