extends Label

func _physics_process(_delta: float) -> void:
	if PlayerStats.DebugMode:
		show()
		text = str(Engine.get_frames_per_second())
	else:
		hide()
