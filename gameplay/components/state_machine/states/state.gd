@abstract
class_name State
extends Node


@warning_ignore("unused_signal")
signal state_changed(state : State, new_state_name : String)


@export var parent_state : State :
	get:
		if parent_state == null:
			parent_state = (get_parent()) if (get_parent() is State) else (null)
		return parent_state


var entity : Entity = null

var propagation_enabled : bool = true


@onready var state_machine : StateMachine = %StateMachine


func _ready() -> void:
	if state_machine == null:
		push_error("Can't assign character because StateMachine is null.")
		return
	if parent_state == null:
		propagation_enabled = false
	entity = state_machine.entity_parent as Entity


@abstract func enter() -> void
@abstract func exit() -> void
@abstract func process() -> void
@abstract func physics_process() -> void

@abstract func _handle_transitions() -> void


func _propagate_enter() -> void:
	if not propagation_enabled:
		return
	parent_state.enter()


func _propagate_exit() -> void:
	if not propagation_enabled:
		return
	parent_state.exit()


func _propagate_process() -> void:
	if not propagation_enabled:
		return
	parent_state.process()


func _propagate_physics_process() -> void:
	if not propagation_enabled:
		return
	parent_state.physics_process()
