extends CharacterBody2D

func _ready() -> void:
	if randi_range(0,30) != 6 and PlayerStats.SpeedrunModeRandomSaltniczka:
		print("[saltniczka.gd] Byeeeeeee, the random number is not 6")
		queue_free()

func _on_button_pressed() -> void:
	LevelMan.FlyingThingAlive = true
	print("[saltniczka.gd] There will be salt")
	queue_free()
