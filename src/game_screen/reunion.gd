class_name Reunion
extends KinematicBody2D

onready var _animated_sprite: AnimatedSprite = $"AnimatedSprite"

export(float) var gravity = 600

var _velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if is_on_floor():
		_velocity = Vector2.ZERO

	_velocity.y += gravity * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)

func unite() -> void:
	_animated_sprite.play("start")
	yield(_animated_sprite, "animation_finished")
	_animated_sprite.play("loop")
