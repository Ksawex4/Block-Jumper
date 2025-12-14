extends Control

@export var Target_pos: Vector2 = Vector2.ZERO
@onready var Speedrun_mode_menu: Window = $"../SpeedrunModeMenu"


func _ready() -> void:
	if SaveMan.get_data_from_file("Save.bj").get("Version") != SaveMan.Game_version:
		$LoadGame/Information.show()


func _physics_process(delta: float) -> void:
	position = lerp(position, Target_pos, 3 * delta)


func _on_new_game_pressed() -> void:
	NovaFunc.reset_all_variables_to_default(false, false, true)
	LevelMan.change_level("trash_room.tscn")


func _on_load_game_pressed() -> void:
	if FileAccess.file_exists("user://Save.bj") and BobMan.Saved_bobs <= 0:
		NovaFunc.reset_all_variables_to_default(false, false, true)
		GameMan.load_game()
	elif BobMan.Saved_bobs > 0:
		$LoadGame.queue_free()


func _on_achievements_pressed() -> void:
	AchievMan.emit_signal("ShowAchievements")


func _on_settings_pressed() -> void:
	SettingsMan.emit_signal("ShowSettings")


func _on_quit_pressed() -> void:
	AchievMan.save_achievements()
	SettingsMan.save_settings()
	get_tree().quit() # maybe add a quit cutscene?


func _on_speedrun_mode_pressed() -> void:
	Speedrun_mode_menu.show()


func _on_file_manager_pressed() -> void:
	$"../FileManager".show()
