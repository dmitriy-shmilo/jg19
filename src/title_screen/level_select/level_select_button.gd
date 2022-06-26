extends Control

signal level_selected(level)

onready var _button: Button = $"Button"

var level: int = 0 setget set_level

func _ready() -> void:
	set_level(level)


func set_level(val) -> void:
	level = val
	if is_inside_tree():
		_button.text = tr("ui_level_caption") % (level + 1)


func _on_Button_pressed() -> void:
	emit_signal("level_selected", level)

