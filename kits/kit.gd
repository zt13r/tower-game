class_name Kit extends Node


@export var actor: Player:
	get:
		if not actor:
			# This sucks
			actor = get_tree().get_first_node_in_group("Player")
		return actor

@export_group("Damage")
@export var basic_attack_damage: float = 2.0
@export var skill_one_damage: float = 7.0
@export var skill_two_damage: float = 12.0
# In seconds
@export_group("Cooldown")
@export var basic_attack_cooldown: float = 0.2
@export var skill_one_cooldown: float = 3.0
@export var skill_two_cooldown: float = 7.0
@export_group("Duration")
@export var basic_attack_duration: float = 0.1
@export var skill_one_duration: float = 0.5
@export var skill_two_duration: float = 0.5


var projectiles: Node2D:
	get:
		if not projectiles:
			projectiles = get_tree().get_first_node_in_group("Projectiles")
		return projectiles

var player_projectiles: Node2D:
	get:
		if not player_projectiles:
			player_projectiles = projectiles.get_child(0)
		return player_projectiles

var enemy_projectiles: Node2D:
	get:
		if not enemy_projectiles:
			enemy_projectiles = projectiles.get_child(1)
		return enemy_projectiles


func basic_attack() -> void:
	pass


func skill_one() -> void:
	pass


func skill_two() -> void:
	pass
