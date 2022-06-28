extends Control
class_name TitleScene

onready var _new_game_button: Button = $"HBoxContainer/NewGameButton"
onready var _quit_button = $"QuitButton"

func _ready():
	_quit_button.visible = not OS.has_feature("HTML5")
	_new_game_button.text = tr("ui_start_game") if UserSaveData.last_level == 0 else tr("ui_continue")
