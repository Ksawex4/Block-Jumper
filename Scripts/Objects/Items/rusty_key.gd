extends Area2D

@export var Door: StaticBody2D


func _on_body_entered(_body: Node2D) -> void:
	if Door:
		Door.explode()
		queue_free()
