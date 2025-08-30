extends Window

func _on_button_pressed() -> void:
	if LevelMan.Os != "Android" and FileAccess.file_exists("user://The Bobs have awoken.BOB") or LevelMan.Os == "Android" and SaveMan.AndroidFileExists("The Bobs have awoken.BOB"):
		var file
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.WRITE)
		else:
			file = SaveMan.AndroidFileGet("The Bobs have awoken.BOB")
		if file:
			var data = {"Bob": -999}
			file.store_string(SaveMan.Encode(data))
			file.close()
	get_tree().quit()
