class_name Hint
extends Node2D

export(String) var text = ""

func _ready() -> void:
	$Label.text = text


func _on_Area2D_body_entered(body: Node) -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Label, "modulate:a", 0.2, 1.0, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()


func _on_Area2D_body_exited(body: Node) -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Label, "modulate:a", 1.0, 0.2, 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
