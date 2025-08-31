extends Control

var targetPosForBatons = Vector2(-355.0, -42.5)

func _on_new_game_pressed() -> void:
	NovaFunc.ResetAllGlobalsToDefault(false, true, false)
	ToastEventMan.GetNewToastAndStartEvent()
	LevelMan.ChangeLevel("res://Scenes/Levels/trash_room.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_load_game_pressed() -> void:
	if !LevelMan.CanPlayerSave:
		$LoadGame.queue_free()
	else:
		NovaFunc.ResetAllGlobalsToDefault(false, true, false)
		SaveMan.LoadGame()

func _on_achievements_pressed() -> void:
	SignalMan.emit_signal("ShowAchievements")

func _on_settings_pressed() -> void:
	SignalMan.emit_signal("ShowSettings")

func _physics_process(_delta: float) -> void:
	position = lerp(position, targetPosForBatons, 0.05)
