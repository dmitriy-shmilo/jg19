class_name Fly
extends KinematicBody2D

const THRESHOLD = 2.0

export(float) var speed = 10

onready var _start = $"Start"
onready var _end = $"End"

onready var _start_pos = _start.global_position
onready var _end_pos = _end.global_position
onready var _target = _end_pos

func _process(delta):
	if global_position.distance_squared_to(_target) <= THRESHOLD * THRESHOLD:
		_target = _end_pos if _target == _start_pos else _start_pos

	var dir = global_position.direction_to(_target)
	move_and_slide(dir * speed, Vector2.UP)
