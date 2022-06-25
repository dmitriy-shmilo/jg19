extends Node
class_name Gui

signal next_level_requested

const COMPLETION_TOP_END = 105
const COMPLETION_TOP_START = -150

onready var _level_complete_tween: Tween = $"LevelComplete/LevelCompleteTween"
onready var _level_complete: PanelContainer = $"LevelComplete"
onready var _retries_label: Label = $"LevelComplete/VBoxContainer/RetriesLabel"
onready var _level_label: Label = $"LevelComplete/VBoxContainer/LevelLabel"
onready var _pause_container: ColorRect = $"PauseContainer"
onready var _pause_controls: Control = $"PauseContainer/PauseControls"
onready var _continue_button: Button = $"PauseContainer/PauseControls/HBoxContainer/ContinueButton"
onready var _settings: SettingsScene = $"PauseContainer/Settings"

func _input(event: InputEvent) -> void:
	if _level_complete_tween.is_active():
		return

	if event is InputEventKey and not event.echo and event.pressed or event is InputEventMouseButton:
		hide_level_complete()


func hide_level_complete() -> void:
	if not _level_complete.visible or _level_complete_tween.is_active():
		return

	_level_complete_tween.stop_all()
	_level_complete_tween.interpolate_property( \
		_level_complete, "rect_position", \
		Vector2(_level_complete.rect_position.x, COMPLETION_TOP_END), \
		Vector2(_level_complete.rect_position.x, COMPLETION_TOP_START), \
		0.75, Tween.TRANS_BACK, Tween.EASE_IN)
	_level_complete_tween.start()

	yield(_level_complete_tween, "tween_all_completed")
	_level_complete.visible = false
	emit_signal("next_level_requested")


func show_level_complete(title: String, retries: int) -> void:
	if _level_complete.visible:
		return

	_level_complete_tween.stop_all()
	_level_complete.visible = true
	_retries_label.text = "%d retries" % [retries]
	_level_label.text = "%s complete" % [title]

	_level_complete_tween.interpolate_property( \
		_level_complete, "rect_position", \
		Vector2(_level_complete.rect_position.x, COMPLETION_TOP_START), \
		Vector2(_level_complete.rect_position.x, COMPLETION_TOP_END), \
		0.75, Tween.TRANS_BACK, Tween.EASE_OUT)
	_level_complete_tween.start()


func unpause() -> void:
	_pause_container.visible = false
	get_tree().paused = false


func pause() -> void:
	get_tree().paused = true
	_pause_container.visible = true
	_continue_button.grab_focus()


func _on_QuitButton_pressed() -> void:
	_pause_container.visible = false
	get_tree().paused = false
	var err = get_tree().change_scene("res://title_screen/title_screen.tscn")
	ErrorHandler.handle(err)


func _on_ContinueButton_pressed() -> void:
	unpause()


func _on_SettingsButton_pressed() -> void:
	_settings.visible = true
	_pause_controls.visible = false


func _on_Settings_BackToTitleButton_pressed() -> void:
	_settings.visible = false
	_pause_controls.visible = true


func _on_LevelComplete_gui_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		hide_level_complete()
