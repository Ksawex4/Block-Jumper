extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	$AnimatedSprite2D.play("explode")
	$AudioStreamPlayer.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	AchievMan.AddAchievement("ParkourGuy")
	queue_free()
