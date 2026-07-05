extends Node
## Handles joystick variables and conditions.


var move_joystick_direction : Vector2 = Vector2.ZERO
var dash_joystick_direction : Vector2 = Vector2.ZERO
var basic_attack_joystick_direction : Vector2 = Vector2.ZERO
var skill_one_joystick_direction : Vector2 = Vector2.ZERO
var skill_two_joystick_direction : Vector2 = Vector2.ZERO

var last_basic_attack_joystick_direction : Vector2 = Vector2.ZERO
var last_skill_one_joystick_direction : Vector2 = Vector2.ZERO
var last_skill_two_joystick_direction : Vector2 = Vector2.ZERO

var dash_joystick_released : bool = false
var basic_attack_joystick_released : bool = false
var skill_one_joystick_released : bool = false
var skill_two_joystick_released : bool = false
