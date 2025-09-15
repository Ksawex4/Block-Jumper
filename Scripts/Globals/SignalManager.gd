extends Node

func _ready() -> void:
	print("[SignalManager.gd] Loaded")

@warning_ignore("unused_signal")
signal Continue() # pause_menu.gd -> InputManager.gd
@warning_ignore("unused_signal")
signal Pause() # InputManager.gd -> pause_menu.gd
@warning_ignore("unused_signal")
signal ShowAchievements() # pause_menu.gd -> achievements_menu.gd
@warning_ignore("unused_signal")
signal UpdateAchievements() # AchievementManager.gd -> achievements_menu.gd
@warning_ignore("unused_signal")
signal SceneChanged() # AchievementManager.gd -> achievements_menu.gd
@warning_ignore("unused_signal")
signal UpdateBars() # achievements_menu.gd
@warning_ignore("unused_signal")
signal ShowSettings() # pause_menu.gd/title_buttons.gd -> settings_menu.gd
@warning_ignore("unused_signal")
signal ChangedLevel() # LevelManager.gd
@warning_ignore("unused_signal")
signal ShowSpeedrunModeWindow()
