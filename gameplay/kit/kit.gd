@abstract
class_name Kit
extends Resource


@export var name : String = ""
@export_multiline var description : String = ""
@export var icon : Texture = null


var player : Player = null


@abstract func use_dash() -> void
@abstract func use_skill_one() -> void
@abstract func use_skill_two() -> void
@abstract func use_skill_three() -> void
