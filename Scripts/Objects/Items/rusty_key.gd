extends Area2D

@export var door: StaticBody2D

func _on_body_entered(_body: Node2D) -> void:
	if door:
		door.explode()
