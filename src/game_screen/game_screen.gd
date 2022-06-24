extends Node2D

const LEVELS = [
	preload("res://game_screen/levels/level0.tscn"),
	preload("res://game_screen/levels/level1.tscn"),
	preload("res://game_screen/levels/level2.tscn"),
	preload("res://game_screen/levels/level3.tscn"),
]

onready var _gui = $"Gui"
onready var _screen_shaker: Shaker = $"ScreenShaker"

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


func _on_level_finished(level: Level) -> void:
	_next_level()
