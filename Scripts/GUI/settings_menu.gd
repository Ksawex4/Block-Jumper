extends Window

var vsync: bool

func _ready() -> void:
	if DisplayServer.window_get_vsync_mode() == 0:
		$VSync.text = "vsync: Enabled"
		vsync = true
	else:
		$VSync.text = "vsync: Disabled"
		vsync = false
	SignalMan.connect("ShowSettings", Callable(self, "show"))
	$MaxFPS.placeholder_text = "MaxFPS: %s" % str(Engine.max_fps)
	$DebugMode.text = "DebugMode %s" % PlayerStats.DebugMode
	if LevelMan.Os == "Android":
		$Controls.queue_free()
		$ControlsMenu.queue_free()
	
	AudioServer.set_bus_volume_db(1, LevelMan.SFXVolume)
	AudioServer.set_bus_volume_db(2, LevelMan.MusicVolume)
	$SFX/HSlider.value = LevelMan.SFXVolume
	$Music/HSlider.value = LevelMan.MusicVolume

func _process(_delta: float) -> void:
	$Music.text = "Music: " + str($Music/HSlider.value) + "DB"
	$SFX.text = "SFX: " + str($SFX/HSlider.value) + "DB"
	LevelMan.SFXVolume = $SFX/HSlider.value
	LevelMan.MusicVolume = $Music/HSlider.value
	AudioServer.set_bus_volume_db(1, LevelMan.SFXVolume)
	AudioServer.set_bus_volume_db(2, LevelMan.MusicVolume)

func _on_vsync_pressed() -> void:
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		$VSync.text = "vsync: Disabled"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		$VSync.text = "vsync: Enabled"
	vsync = not vsync

func _on_close_requested() -> void:
	hide()

func _on_max_fps_text_submitted(new_text: String) -> void:
	var FPS: int = int(new_text)
	if FPS >= 0:
		Engine.max_fps = FPS
		if FPS != 0:
			$MaxFPS.placeholder_text = "MaxFPS: " + str(FPS)
		else:
			$MaxFPS.placeholder_text = "MaxFPS: Unlimited"
		$MaxFPS.text = ""

func _on_debug_mode_pressed() -> void:
	PlayerStats.DebugMode = not PlayerStats.DebugMode
	$DebugMode.text = "DebugMode %s" % PlayerStats.DebugMode
	if !PlayerStats.DebugMode:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/Levels/title_screen.tscn")

func _on_controls_pressed() -> void:
	$ControlsMenu.show()
