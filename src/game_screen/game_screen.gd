extends Node2D

const DEATH_SOUND = preload("res://assets/sound/death.wav")
const REUNION_SOUND = preload("res://assets/sound/reunion.wav")
const LEVELS = [
	preload("res://game_screen/levels/level0.tscn"),
	preload("res://game_screen/levels/level1.tscn"),
	preload("res://game_screen/levels/level2.tscn"),
	preload("res://game_screen/levels/level3.tscn"),
]

onready var _gui = $"Gui"
onready var _screen_shaker: Shaker = $"ScreenShaker"
onready var _audio_player = $"AudioPlayer"
onready var _fader: Fader = $"Fader"
var _current_level = 0
var _level: Level = null

func _ready() -> void:
	_next_level()


func _process(_event):
	if Input.is_action_just_pressed("system_pause"):
		_gui.pause()


func _next_level() -> void:
	var scene = LEVELS[_current_level % LEVELS.size()]
	_current_level += 1

	if _level != null:
		_level.disconnect("finished", self, "_on_level_finished")
		_level.queue_free()

	_level = scene.instance()
	_level.connect("lost", self, "_on_level_lost")
	_level.connect("finished", self, "_on_level_finished")
	add_child(_level)


func _on_level_lost(level: Level) -> void:
	_screen_shaker.shake_horizontal(self, "position", 8, 5, 0.25)
	_audio_player.stream = DEATH_SOUND
	_audio_player.play()


func _on_level_finished(level: Level, retries: int) -> void:
	_gui.show_level_complete(level.level_title, retries, _current_level >= LEVELS.size())
	_audio_player.stream = REUNION_SOUND
	_audio_player.play()


func _on_Gui_next_level_requested() -> void:
	_fader.fade_out()
	yield(_fader, "fade_out_completed")

	if _current_level >= LEVELS.size():
		get_tree().change_scene("res://title_screen/title_screen.tscn")
	else:
		_next_level()
	_fader.fade_in()
