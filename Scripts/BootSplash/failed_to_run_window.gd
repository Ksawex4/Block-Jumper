extends Window

func _on_button_pressed() -> void:
	BobMan.save_bobs()
	AchievMan.save_achievements()
	SettingsMan.save_settings()
	if not GameMan.Speedrun_mode:
		get_tree().quit()
	else:
		LevelMan.change_level("boot_screen.tscn")
		NovaFunc.reset_all_variables_to_default(false, false, true)
