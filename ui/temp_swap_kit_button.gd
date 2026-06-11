extends Button


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


func _on_pressed() -> void:
	player.swap_kit()
	text = player.current_kit.name
