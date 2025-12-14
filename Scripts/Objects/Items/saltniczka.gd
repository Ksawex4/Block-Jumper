extends Button

func _ready() -> void:
	if GameMan.Random_saltniczka and randi_range(0,30) != 6:
		queue_free()


func _on_pressed() -> void:
	LevelMan.Spawn_flying_thing = true
	DebugMan.dprint("[saltniczka, _on_pressed] It's... SALTSANDTIME")
	queue_free()
