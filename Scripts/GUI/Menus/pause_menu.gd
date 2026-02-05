extends Window


func _init() -> void:
	GameMan.connect("PauseGame", Callable(self, "show"))


func _ready() -> void:
	add_theme_font_override("title_font", NovaFont.get_font(&"main"))
	NovaFont.ReloadFont.connect(_update_font)


func _update_font() -> void:
	add_theme_font_override("title_font", NovaFont.get_font(&"main"))


func _on_continue_game_pressed() -> void:
	GameMan.toggle_pause(false)
	hide()


func _on_achievements_pressed() -> void:
	AchievMan.emit_signal("ShowAchievements")


func _on_settings_pressed() -> void:
	SettingsMan.emit_signal("ShowSettings")


func _on_quit_to_tile_pressed() -> void:
	if LevelMan.Can_quit_level:
		GameMan.toggle_pause(false)
		LevelMan.change_level("title_screen.tscn")
