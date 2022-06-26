class_name Fly
extends KinematicBody2D

const THRESHOLD = 2.0

export(float) var speed = 10
export(float) var reset_speed = 100

onready var _start = $"Start"
onready var _end = $"End"
onready var _init_pos = global_position
onready var _start_pos = _start.global_position
onready var _end_pos = _end.global_position
onready var _target = _end_pos

var _is_resetting = false

func _process(delta):
	var dir = Vector2.ZERO
	var spd = 0.0
	if _is_resetting:
		spd = reset_speed
		if global_position.distance_squared_to(_init_pos) <= THRESHOLD * THRESHOLD:
			_is_resetting = false
			_target = _end_pos
			return
		else:
			dir = global_position.direction_to(_init_pos)
	else:
		spd = speed
		if global_position.distance_squared_to(_target) <= THRESHOLD * THRESHOLD:
			_target = _end_pos if _target == _start_pos else _start_pos
			return
		dir = global_position.direction_to(_target)

	move_and_slide(dir * spd)


func reset() -> void:
	_is_resetting = true
