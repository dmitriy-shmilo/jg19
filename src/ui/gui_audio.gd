extends Node

const HOWER_SOUNDS = [
	preload("res://assets/sound/sfx_ui_hover-001.wav"),
	preload("res://assets/sound/sfx_ui_hover-002.wav"),
	preload("res://assets/sound/sfx_ui_hover-003.wav"),
	preload("res://assets/sound/sfx_ui_hover-004.wav")
]
const CLICK_SOUNDS = [
	preload("res://assets/sound/sfx_ui_button_click-001.wav"),
	preload("res://assets/sound/sfx_ui_button_click-002.wav"),
	preload("res://assets/sound/sfx_ui_button_click-003.wav")
]
var _player: AudioStreamPlayer

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.bus = "Sfx"
	add_child(_player)


func play_hower() -> void:
	_player.stream = HOWER_SOUNDS[randi() % HOWER_SOUNDS.size()]
	_player.play()


func play_click() -> void:
	_player.stream = CLICK_SOUNDS[randi() % CLICK_SOUNDS.size()]
	_player.play()
