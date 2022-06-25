class_name Corpse
extends KinematicBody2D

export(bool) var is_mirror = false

var is_active = false

func start() -> void:
	is_active = true
	visible = true
	$AnimatedSprite.play("start" + ("_mirror" if is_mirror else ""))
	$Timer.start()


func _on_Timer_timeout() -> void:
	$AnimatedSprite.play("end" + ("_mirror" if is_mirror else ""))


func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation.begins_with("end"):
		is_active = false
		visible = false
