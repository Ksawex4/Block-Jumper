extends Window

func _on_button_pressed() -> void:
	if (LevelMan.Os != "Android" or LevelMan.IsWeb) and FileAccess.file_exists("user://The Bobs have awoken.BOB") or LevelMan.Os == "Android" and not LevelMan.IsWeb and SaveMan.AndroidFileExists("The Bobs have awoken.BOB"):
		var file: FileAccess
		if LevelMan.Os != "Android" or LevelMan.IsWeb:
			file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.WRITE)
		else:
			file = SaveMan.AndroidFileGet("The Bobs have awoken.BOB")
		if file:
			var data: Dictionary = {"Bob": -1}
			file.store_string(SaveMan.Encode(data))
			file.close()
			print("[FailedToRunWindow.gd] Saved Bobs, data: ", data)
		if !PlayerStats.SpeedrunMode:
			get_tree().quit()
		else:
			get_tree().reload_current_scene()
			BobMan.ResetVariablesToDefault()
