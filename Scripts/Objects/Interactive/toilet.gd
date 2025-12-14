extends Area2D

var Colliding: int = 0


func _on_body_entered(_body: Node2D) -> void:
	$Label.show()
	Colliding += 1


func _on_body_exited(_body: Node2D) -> void:
	Colliding -= 1
	if Colliding == 0:
		$Label.hide()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and Colliding > 0:
		LevelMan.change_level("sewers.tscn")
