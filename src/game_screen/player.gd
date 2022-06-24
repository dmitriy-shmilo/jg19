class_name Player
extends KinematicBody2D

export(float) var speed = 150
export(float) var acceleration = 1000
export(float) var jump_speed = 500
export(float) var gravity = 1000
export(float) var jump_half_time = .25
export(float) var jump_height = 50
export(bool) var is_mirror = false

var _input: Vector2 = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO
var _can_jump: bool = false
var _x_multiplier: float = 1.0

onready var _coyote_timer: Timer = $"CoyoteTimer"

func _ready() -> void:
	gravity = 2 * jump_height / (jump_half_time * jump_half_time)
	jump_speed = gravity * jump_half_time
	_x_multiplier = -1.0 if is_mirror else 1.0


func _process(delta: float) -> void:
	if is_on_floor():
		_can_jump = true
	elif _can_jump and _coyote_timer.is_stopped():
		_coyote_timer.start()

	_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_input.x *= _x_multiplier

	if _input.x != 0:
		_velocity.x = move_toward(_velocity.x, _input.x * speed, acceleration * delta)
	else:
		_velocity.x = move_toward(_velocity.x, 0, 2 * acceleration * delta)

	if _can_jump and Input.is_action_just_pressed("up"):
		_velocity.y = -jump_speed
		_can_jump = false
	else:
		_velocity.y += gravity * delta

	_velocity = move_and_slide(_velocity, Vector2.UP)


func _on_CoyoteTimer_timeout() -> void:
	_can_jump = false
