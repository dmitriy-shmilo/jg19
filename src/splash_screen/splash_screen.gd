extends Control

onready var _fader: Fader = $"Fader"

func _ready() -> void:
	yield(_fader, "fade_in_completed")
	Settings.load_settings()
	UserSaveData.load_data()
	_fader.fade_out()
	yield(_fader, "fade_out_completed")
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)
	GuiAudio.pause_mode = Node.PAUSE_MODE_PROCESS
