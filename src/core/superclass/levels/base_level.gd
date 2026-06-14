@abstract
class_name BaseLevel
extends Node2D
## Abstract class for levels.


## Provides the player spawn in the level.
@abstract func get_player_spawn() -> Vector2

## Provides the camera used in the level.
@abstract func get_player_camera() -> Camera2D
