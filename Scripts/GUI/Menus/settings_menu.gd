extends Window

var Vsync: bool
@export var VSyncNode: Button
@export var DebugMode: Button
@export var BasicDebugNode: Button
@export var MaxFPS: LineEdit
@export var Controls: Button
@export var SFX: HSlider
@export var SFXLabel: Label
@export var Music: HSlider
@export var MusicLabel: Label
@export var BossCamToggle: Button

func _ready() -> void:
	SettingsMan.connect("ShowSettings", Callable(self, "_show"))
	VSyncNode.text = "VSYNC: false" if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED else "VSYNC: true"
	BasicDebugNode.text = "Debug Info: true" if DebugMan.Basic_debug else "Debug Info: false"
	
	#MaxFPS.placeholder_text = "MaxFPS: %s" % str(Engine.max_fps)
	$MaxFPS/Label.text = "MaxFPS: %s" % str(Engine.max_fps)
	$MaxFPS.value = Engine.max_fps
	DebugMode.text = "DebugMode %s" % DebugMan.Debug_mode
	SFX.value = SettingsMan.SFX_volume
	Music.value = SettingsMan.Music_volume
	
	if GameMan.is_mobile():
		$ControlsMenu.queue_free()
		$Controls.queue_free()
	
	if SettingsMan.StaticBossCamera:
		BossCamToggle.text = "BossCam: Static"
	else:
		BossCamToggle.text = "BossCam: Follow"


func _process(_delta: float) -> void:
	MusicLabel.text = "Music: " + str(Music.value) + "DB"
	SFXLabel.text = "SFX: " + str(SFX.value) + "DB"
	if int($MaxFPS.value) != 0:
		$MaxFPS/Label.text = "MaxFPS: " + str($MaxFPS.value)
	else:
		$MaxFPS/Label.text = "MaxFPS: Unlimited"
	SettingsMan.SFX_volume = SFX.value
	SettingsMan.Music_volume = Music.value
	AudioServer.set_bus_volume_db(1, SettingsMan.SFX_volume)
	AudioServer.set_bus_volume_db(2, SettingsMan.Music_volume)


func _on_controls_pressed() -> void:
	$ControlsMenu.show()


func _on_close_requested() -> void:
	hide()
	SettingsMan.save_settings()

func _show() -> void:
	show()


func _on_debug_mode_pressed() -> void:
	DebugMan.Debug_mode = not DebugMan.Debug_mode
	DebugMode.text = "DebugMode %s" % DebugMan.Debug_mode
	if not DebugMan.Debug_mode:
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/Levels/title_screen.tscn")


func _on_max_fps_drag_ended(value_changed: bool) -> void:
	if value_changed:
		Engine.max_fps = int($MaxFPS.value)


func _on_v_sync_pressed() -> void:
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		VSyncNode.text = "VSYNC: true"
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		VSyncNode.text = "VSYNC: false"


func _on_basic_debug_pressed() -> void:
	if DebugMan.Basic_debug == false:
		DebugMan.Basic_debug = true
		BasicDebugNode.text = "Debug Info: true"
	else:
		DebugMan.Basic_debug = false
		BasicDebugNode.text = "Debug Info: false"


func _on_camera_boss_type_toggle_pressed() -> void:
	SettingsMan.StaticBossCamera = not SettingsMan.StaticBossCamera
	if SettingsMan.StaticBossCamera:
		BossCamToggle.text = "BossCam: Static"
	else:
		BossCamToggle.text = "BossCam: Follow"
