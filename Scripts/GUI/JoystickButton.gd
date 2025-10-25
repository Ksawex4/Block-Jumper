extends TouchScreenButton

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		print(event.index, event.device)
