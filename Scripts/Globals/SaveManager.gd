extends Node

var GameVersion: Variant = ProjectSettings.get_setting("application/config/version")
var AndroidSaveDirectory: String = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Nova-Games/Block-Jumper/"

func _ready() -> void:
	print("[SaveManager.gd] Loaded")

func Encode(data: Dictionary) -> String:
	var jsonStr: String = JSON.stringify(data) # yup, encoding in this game is pretty simple, so if you want to cheat, go on, im not stopping you, just there might be a possibility of some things breaking
	return Marshalls.utf8_to_base64(jsonStr)

func DecodeAndParse(encodedString: String) -> Variant:
	var decoded: String = Marshalls.base64_to_utf8(encodedString)
	return JSON.parse_string(decoded)

func SaveGame(pos: Vector2) -> void:
	var data: Dictionary = {
		"Version": GameVersion,
		"xPos": pos.x,
		"yPos": pos.y,
		"AllPlayerStats": PlayerStats.AllPlayerStats,
		"Beans": PlayerStats.Beans,
		"Level": get_tree().current_scene.scene_file_path,
		"PKeys": LevelMan.PersistenceKeys,
		"Chip": PlayerStats.Chip,
		"Toast": ToastEventMan.Toast,
		"FollowingWho": PlayerStats.FollowWho,
	}
	var encodedStr: String = Encode(data)
	if LevelMan.Os == "Android" and not LevelMan.IsWeb:
		AndroidSave(encodedStr, "Save.bj")
	else:
		var file: FileAccess = FileAccess.open("user://Save.bj", FileAccess.WRITE)
		file.store_string(encodedStr)
		file.close()
		print("[SaveManager.gd] Saved the game, data: ", data)

func LoadGame() -> void:
	if FileAccess.file_exists("user://Save.bj") and (LevelMan.Os != "Android" or LevelMan.IsWeb) or LevelMan.Os == "Android" and not LevelMan.IsWeb and AndroidFileExists("Save.bj"):
		var file: FileAccess
		if (LevelMan.Os != "Android" or LevelMan.IsWeb):
			file = FileAccess.open("user://Save.bj", FileAccess.READ)
		else:
			file = AndroidFileGet("Save.bj")
		if file:
			var data: Dictionary = DecodeAndParse(file.get_as_text())
			var level: String
			var loadPos: Vector2
			if data is Dictionary:
				loadPos = Vector2(data["xPos"], data["yPos"])
				PlayerStats.AllPlayerStats = data["AllPlayerStats"]
				PlayerStats.Beans = data["Beans"]
				level = data["Level"]
				LevelMan.PersistenceKeys = data["PKeys"]
				PlayerStats.Chip = data["Chip"]
				ToastEventMan.Toast = data["Toast"]
				PlayerStats.FollowWho = data["FollowingWho"]
			file.close()
			if level and ResourceLoader.exists(level):
				get_tree().change_scene_to_file(level)
				await SignalMan.SceneChanged
				for x in get_tree().get_nodes_in_group("players"):
					x.position = loadPos 

func AndroidSave(data: String, fileName: String) -> void:
	var fullPath: String = AndroidSaveDirectory + fileName
	if !DirAccess.dir_exists_absolute(AndroidSaveDirectory):
		var error: Error = DirAccess.make_dir_recursive_absolute(AndroidSaveDirectory)
		if error == OK:
			print("[SaveManager.gd] Created Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
		else:
			print("[SaveManager.gd] Failed to create Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	var file: FileAccess = FileAccess.open(fullPath, FileAccess.WRITE)
	if file:
		file.store_string(data)
		file.close()
		print("[SaveManager.gd] Saved the game in ", AndroidSaveDirectory, " data: ", data)

func AndroidFileGet(FileName: String) -> FileAccess:
	return FileAccess.open(AndroidSaveDirectory + FileName, FileAccess.READ_WRITE)

func AndroidFileExists(FileName: String) -> bool:
	if FileAccess.file_exists(AndroidSaveDirectory + FileName):
		return true
	return false

func SaveSettings() -> void:
	var data := {
		"MusicVolume": LevelMan.MusicVolume,
		"SFXVolume": LevelMan.SFXVolume,
		"VSync": DisplayServer.window_get_vsync_mode(),
		"MaxFPS": Engine.max_fps,
	}  # Controls are not saved beacuse I don't currently know how to do that
	if LevelMan.Os == "Android" and not LevelMan.IsWeb:
		AndroidSave(JSON.stringify(data), "Settings.bj")
	else:
		var file: FileAccess = FileAccess.open("user://Settings.bj", FileAccess.WRITE)
		file.store_string(JSON.stringify(data))
		file.close()
		print("[SaveManager.gd] Saved Settings, data: ", data)

func LoadSettings() -> void:
	if FileAccess.file_exists("user://Save.bj") and (LevelMan.Os != "Android" or LevelMan.IsWeb) or LevelMan.Os == "Android" and not LevelMan.IsWeb and AndroidFileExists("Save.bj"):
		var file: FileAccess
		if LevelMan.Os != "Android" or LevelMan.IsWeb:
			file = FileAccess.open("user://Settings.bj", FileAccess.READ)
		else:
			file = AndroidFileGet("Settings.bj")
		if file:
			var data = JSON.parse_string(file.get_as_text())
			if data is Dictionary:
				LevelMan.MusicVolume = data["MusicVolume"]
				LevelMan.SFXVolume = data["SFXVolume"]
				DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED if data["VSync"] == 1 else DisplayServer.VSYNC_ENABLED)
				Engine.max_fps = data["MaxFPS"]
			file.close()
