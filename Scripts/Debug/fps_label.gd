extends Label

func _process(_delta: float) -> void:
	if DebugMan.Basic_debug:
		if not visible:
			show()
		text = "FPS: " + str(Engine.get_frames_per_second())
	else:
		if visible:
			hide()
		text = ""
