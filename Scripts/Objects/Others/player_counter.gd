extends Area2D

var playerCount: int = 0

func _on_body_entered(_body: Node2D) -> void:
	playerCount += 1


func _on_body_exited(_body: Node2D) -> void:
	playerCount -= 1
