class_name ButtonBase
extends Button


func _ready() -> void:
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("button_down", self, "_on_click")


func _on_mouse_entered() -> void:
	GuiAudio.play_hower()


func _on_click() -> void:
	GuiAudio.play_click()
