extends Area2D

var colliding: bool = false

func _on_body_entered(_body: Node2D) -> void:
	$Label.show()
	colliding = true

func _on_body_exited(_body: Node2D) -> void:
	$Label.hide()
	colliding = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interract"):
		LevelMan.ChangeLevel("sewers")
