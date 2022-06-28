extends Control
class_name CreditsScene

onready var _credits_text: RichTextLabel = $"PanelContainer/VBoxContainer/CreditsText"

func _ready() -> void:
	_credits_text.bbcode_text = tr("txt_credits")


func _on_CreditsText_meta_clicked(meta):
	var err = OS.shell_open(meta)
	ErrorHandler.handle(err)
