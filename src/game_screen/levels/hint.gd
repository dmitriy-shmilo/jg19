tool
class_name Hint
extends Node2D

export(String) var text = ""
export(Array, String) var placeholder_keys = []

onready var _label = $"Label"
onready var _tween = $"Tween"

func _ready() -> void:
	var keys = []
	for k in placeholder_keys:
		keys.append(InputMap.get_action_list(k)[0].as_text())

	if keys.size() > 0:
		_label.text = tr(text) % keys
	else:
		_label.text = tr(text)


func _on_Area2D_body_entered(body: Node) -> void:
	_tween.stop_all()
	_tween.interpolate_property(_label, "modulate:a", 0.2, 1.0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()


func _on_Area2D_body_exited(body: Node) -> void:
	_tween.stop_all()
	_tween.interpolate_property(_label, "modulate:a", 1.0, 0.2, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	_tween.start()
