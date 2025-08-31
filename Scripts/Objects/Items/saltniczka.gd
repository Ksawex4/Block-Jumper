extends CharacterBody2D

func _ready() -> void:
	if randi_range(0,100) != 6:
		queue_free()

func _on_button_pressed() -> void:
	LevelMan.FlyingThingAlive = true
	LevelMan.SaltniczkaRandomNumber = 5
	queue_free()
