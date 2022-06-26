extends Node2D

const DEATH_SOUND = preload("res://assets/sound/sfx_char_death.wav")
const REUNION_SOUND = preload("res://assets/sound/sfx_char_reunite.wav")


onready var _gui = $"Gui"
onready var _screen_shaker: Shaker = $"ScreenShaker"
onready var _audio_player = $"AudioPlayer"
onready var _fader: Fader = $"Fader"
var _current_level = 0
var _level: Level = null


func _ready() -> void:
	_current_level = UserSaveData.last_level
	_next_level()


func _process(_event):
	if Input.is_action_just_pressed("system_pause"):
		_gui.pause()


func _next_level() -> void:
	var scene = Levels.LEVELS[_current_level % Levels.LEVELS.size()]
	_current_level += 1

	if _level != null:
		_level.disconnect("finished", self, "_on_level_finished")
		_level.queue_free()

	_level = scene.instance()
	_level.connect("lost", self, "_on_level_lost")
	_level.connect("finished", self, "_on_level_finished")
	add_child(_level)


func _on_level_lost(level: Level) -> void:
	if Settings.screenshake:
		_screen_shaker.shake_horizontal(self, "position", 8, 5, 0.25)
	_audio_player.stream = DEATH_SOUND
	_audio_player.play()


func _on_level_finished(level: Level, retries: int) -> void:
	_gui.show_level_complete(_current_level, retries, _current_level >= Levels.LEVELS.size())
	_audio_player.stream = REUNION_SOUND
	_audio_player.play()


func _on_Gui_next_level_requested() -> void:
	_fader.fade_out()

	yield(_fader, "fade_out_completed")

	UserSaveData.last_level = _current_level
	UserSaveData.last_unlocked_level = max(UserSaveData.last_unlocked_level, _current_level)
	UserSaveData.save_data()

	if _current_level >= Levels.LEVELS.size():
		get_tree().change_scene("res://title_screen/title_screen.tscn")
	else:
		_next_level()

	_fader.fade_in()
