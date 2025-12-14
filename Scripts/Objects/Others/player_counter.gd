extends Area2D

var Player_count: int = 0


func _on_body_entered(_body: Node2D) -> void:
	Player_count += 1


func _on_body_exited(_body: Node2D) -> void:
	Player_count -= 1
