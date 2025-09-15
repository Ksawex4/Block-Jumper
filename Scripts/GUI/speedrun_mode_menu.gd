extends Window

var toast: int = -1

func _ready() -> void:
	SignalMan.connect("ShowSpeedrunModeWindow", Callable(self, "show"))

func _on_toast_text_submitted(new_text: String) -> void:
	toast = int(new_text)
	$Toast.text = ""
	$Toast/Label.text = str(toast)

func _on_start_pressed() -> void:
	if LevelMan.Os != "Android":
		DirAccess.remove_absolute("user://The Bobs have awoken.BOB")
	else:
		DirAccess.remove_absolute(SaveMan.AndroidSaveDirectory + "The Bobs have awoken.BOB")
	LevelMan.SpeedrunTimer = {"Hours": 0, "Minutes": 0, "Seconds": 0, "Frames": 0}
	NovaFunc.ResetAllGlobalsToDefault(true, true)
	ToastEventMan.Toast = toast
	PlayerStats.SpeedrunMode = true
	get_tree().reload_current_scene()

func _on_close_requested() -> void:
	hide()

func _on_saltniczka_pressed() -> void:
	PlayerStats.SpeedrunModeRandomSaltniczka = not PlayerStats.SpeedrunModeRandomSaltniczka
	$Saltniczka/Label.text = str(PlayerStats.SpeedrunModeRandomSaltniczka)
