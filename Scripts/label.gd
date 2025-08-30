extends Label

func _physics_process(_delta: float) -> void:
	if PlayerStats.DebugMode:
		show()
		text = str(Engine.get_frames_per_second())
		
		if Input.is_key_pressed(KEY_F11):
			SaveMan.SaveGame(Vector2(0.0, 0.0))
	else:
		hide()
