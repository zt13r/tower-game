@abstract
class_name Entity
extends CharacterBody2D


func _ready() -> void:
	_init_entity()


func _init_entity() -> void:
	if not is_in_group("Entity"):
		add_to_group("Entity")
