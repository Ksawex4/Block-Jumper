extends StaticBody2D

func explode() -> void:
	$Boom.show()
	$Boom.play("default")
	$Sprite2D.hide()

func _on_boom_animation_finished() -> void:
	queue_free()
