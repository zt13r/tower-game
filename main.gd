class_name Main extends Node2D


@onready var entities: Node2D = $Entities
@onready var projectiles: Node2D = $Projectiles


func _ready() -> void:
	y_sort_enabled = true
	for entity in (entities.get_children() as Array[Entity]):
		entity.y_sort_enabled = true
