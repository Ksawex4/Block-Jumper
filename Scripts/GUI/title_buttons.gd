extends Control

var targetPosForBatons: Vector2 = Vector2(-355.0, -42.5)

func _on_new_game_pressed() -> void:
	NovaFunc.ResetAllGlobalsToDefault(true, false)
	ToastEventMan.GetNewToastAndStartEvent()
	print("[title_buttons, New] Started New game")
	LevelMan.ChangeLevel("res://Scenes/Levels/trash_room.tscn")

func _on_quit_pressed() -> void:
	print("[title_buttons, Quit] Quitting")
	AchievMan.SaveAchievements()
	get_tree().quit()

func _on_load_game_pressed() -> void:
	if !LevelMan.CanPlayerSave:
		$LoadGame.queue_free()
	else:
		print("[title_buttons, Load] Loading the Saved game")
		NovaFunc.ResetAllGlobalsToDefault(true, false)
		SaveMan.LoadGame()

func _on_achievements_pressed() -> void:
	SignalMan.emit_signal("ShowAchievements")

func _on_settings_pressed() -> void:
	SignalMan.emit_signal("ShowSettings")

func _physics_process(_delta: float) -> void:
	position = lerp(position, targetPosForBatons, 0.05)
