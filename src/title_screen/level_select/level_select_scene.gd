class_name LevelSelectScene
extends Control

signal level_selected(level)

const BUTTON_SCENE = preload("res://title_screen/level_select/level_select_button.tscn")

onready var _grid_container: GridContainer = $"VBoxContainer/GridContainer"

func _ready() -> void:
	for i in range(UserSaveData.last_unlocked_level + 1):
		if Levels.LEVELS.size() <= i:
			printerr("Last unlocked level is higher than the amount of levels")
			UserSaveData.last_unlocked_level -= 1
			UserSaveData.save_data()
			break

		var button = BUTTON_SCENE.instance()
		button.level = i
		button.connect("level_selected", self, "_on_level_selected")
		_grid_container.add_child(button)


func _on_level_selected(level: int) -> void:
	emit_signal("level_selected", level)

