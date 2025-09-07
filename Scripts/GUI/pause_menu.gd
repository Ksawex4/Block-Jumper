extends Window

func _ready() -> void:
	SignalMan.connect("Pause", Callable(self, "_on_pause"))

func _on_continue_game_pressed() -> void:
	hide()
	SignalMan.emit_signal("Continue")

func _on_quit_to_title_pressed() -> void:
	hide()
	SignalMan.emit_signal("Continue")
	print("[pause_menu.gd] Quitting to title screen")
	LevelMan.call_deferred("ChangeLevel","res://Scenes/Levels/title_screen.tscn")

func _on_pause() -> void:
	show()

func _on_achievements_pressed() -> void:
	SignalMan.emit_signal("ShowAchievements")

func _on_settings_pressed() -> void:
	SignalMan.emit_signal("ShowSettings")
