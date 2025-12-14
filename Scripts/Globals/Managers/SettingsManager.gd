extends Node

signal ShowSettings()
var Music_volume: float = 0.0
var SFX_volume: float = 0.0


func toggle_vsync() -> void:
	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_DISABLED:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _process(_delta: float) -> void:
	AudioServer.set_bus_volume_db(1, SettingsMan.SFX_volume)
	AudioServer.set_bus_volume_db(2, SettingsMan.Music_volume)


func save_settings() -> void:
	var data := {
		"MusicVolume": Music_volume,
		"SFXVolume": SFX_volume,
		"VSync": DisplayServer.window_get_vsync_mode(),
		"MaxFPS": Engine.max_fps,
		"Controls": InputMan.Saved_controls,
		"DebugInfo": DebugMan.Basic_debug,
	}
	SaveMan.save_file("Settings.bj", data, false)


func load_settings() -> void:
	var data := SaveMan.get_data_from_file("Settings.bj", false)
	if data:
		Music_volume = data.get("MusicVolume", 0.0)
		SFX_volume = data.get("SFXVolume", 0.0)
		if int(data.get("VSync")) == 0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		Engine.max_fps = data.get("MaxFPS", 60)
		InputMan.load_keys(data.get("Controls"))
		DebugMan.Basic_debug = data.get("DebugInfo", false)


func reset_variables_to_default(reset: bool=false) -> void:
	if reset:
		SFX_volume = 0.0
		Music_volume = 0.0
		Engine.max_fps = 60
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	DebugMan.dprint("[SettingsMan, reset_variables_to_default] done ", reset)
