class_name Player
extends KinematicBody2D

const PLAYER_FRAMES = preload("res://assets/textures/player_frames.tres")
const PLAYER_FRAMES_MIRROR = preload("res://assets/textures/player_frames_alt.tres")
const JUMP_SOUND = preload("res://assets/sound/jump.wav")
const FALL_SOUND = preload("res://assets/sound/fall.wav")

signal died(sender)
signal joined()

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
var _jump_released: bool = false

onready var _sprite: AnimatedSprite = $"Sprite"
onready var _coyote_timer: Timer = $"CoyoteTimer"
onready var _audio_player: AudioStreamPlayer = $"AudioPlayer"

func _ready() -> void:
	_sprite.frames = PLAYER_FRAMES if not is_mirror else PLAYER_FRAMES_MIRROR
	gravity = 2 * jump_height / (jump_half_time * jump_half_time)
	jump_speed = gravity * jump_half_time
	_x_multiplier = -1.0 if is_mirror else 1.0
	scale.x = _x_multiplier


func _unhandled_input(event: InputEvent) -> void:
	if not is_mirror and event.is_action_pressed("retry"):
		emit_signal("died", self)
	
	if event.is_action_released("jump"):
		_jump_released = true


func _process(delta: float) -> void:
	if is_on_floor():
		if not _can_jump:
			_audio_player.stream = FALL_SOUND
			_audio_player.play()
		_can_jump = true
	elif _can_jump and _coyote_timer.is_stopped():
		_coyote_timer.start()

	_input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	_input.x *= _x_multiplier

	if _input.x != 0:
		_sprite.play("walk")
		_sprite.flip_h = _input.x < 0
		_velocity.x = move_toward(_velocity.x, _input.x * speed, acceleration * delta)
	else:
		_sprite.play("default")
		_velocity.x = move_toward(_velocity.x, 0, 2 * acceleration * delta)

	if _can_jump and Input.is_action_just_pressed("jump"):
		_sprite.play("jump")
		_velocity.y = -jump_speed
		_can_jump = false
		_jump_released = false
		_audio_player.stream = JUMP_SOUND
		_audio_player.play()
	else:
		_velocity.y += gravity * delta
		if _jump_released:
			_velocity.y += gravity * delta

	_velocity = move_and_slide(_velocity, Vector2.UP)

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("damage"):
			emit_signal("died", self)
			break
		elif collision.collider.is_in_group("player"):
			emit_signal("joined")
			break


func reset() -> void:
	_velocity = Vector2.ZERO
	_can_jump = false
	_coyote_timer.stop()


func _on_CoyoteTimer_timeout() -> void:
	_can_jump = false
