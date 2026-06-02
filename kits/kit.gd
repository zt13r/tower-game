class_name Kit extends Node


@export var actor: Player:
	get:
		if not actor:
			# This sucks
			actor = get_tree().get_first_node_in_group("Player")
		return actor

# In seconds
@export var basic_attack_cooldown: float = 0.2
@export var skill_one_cooldown: float = 3.0
@export var skill_two_cooldown: float = 7.0


var projectiles_node_group: Node2D:
	get:
		if not projectiles_node_group:
			projectiles_node_group = get_tree().get_first_node_in_group("Projectiles")
		return projectiles_node_group


func basic_attack() -> void:
	pass


func skill_one() -> void:
	pass


func skill_two() -> void:
	pass
