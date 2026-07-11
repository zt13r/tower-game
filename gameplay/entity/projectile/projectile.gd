@abstract
class_name Projectile
extends Entity


var damage : float = 0.0
var movement_speed : float = 0.0

var direction : Vector2 = Vector2.ZERO

var fired_by : Character = null


@abstract func apply_hit_effect(target : Character) -> void
