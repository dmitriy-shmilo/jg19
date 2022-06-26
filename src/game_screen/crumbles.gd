class_name Crumbles
extends Node2D

func _ready() -> void:
	$AnimatedSprite.play("default")


func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()
