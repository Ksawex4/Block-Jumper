extends Node

var GameVersion = ProjectSettings.get_setting("application/config/version")
var AndroidSaveDirectory = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Nova-Games/Block-Jumper/"

func Encode(data: Dictionary):
	var jsonStr = JSON.stringify(data)
	var encoded = Marshalls.utf8_to_base64(jsonStr) # yup, encoding in this game is pretty simple, so if you want to cheat, go on, im not stopping you, just there might be a possibility of some things breaking
	return encoded

func DecodeAndParse(encodedString):
	var decoded = Marshalls.base64_to_utf8(encodedString)
	return JSON.parse_string(decoded)

func SaveGame(pos):
	var data = {
		"Version": GameVersion,
		"xPos": pos.x,
		"yPos": pos.y,
		"AllPlayerStats": PlayerStats.AllPlayerStats,
		"Beans": PlayerStats.Beans,
		"Level": get_tree().current_scene.scene_file_path,
		"PKeys": LevelMan.PersistenceKeys,
		"Chip": PlayerStats.Chip,
		"Toast": ToastEventMan.Toast
	}
	var encodedStr = Encode(data)
	if LevelMan.Os == "Android":
		AndroidSave(encodedStr, "Save.bj")
	else:
		var file = FileAccess.open("user://Save.bj", FileAccess.WRITE)
		file.store_string(encodedStr)
		file.close()

func LoadGame():
	if FileAccess.file_exists("user://Save.bj") and LevelMan.Os != "Android" or LevelMan.Os == "Android" and AndroidFileExists("Save.bj"):
		var file
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://Save.bj", FileAccess.READ)
		else:
			file = AndroidFileGet("Save.bj")
		if file:
			var data = DecodeAndParse(file.get_as_text())
			var level
			var loadPos
			if data is Dictionary:
				loadPos = Vector2(data["xPos"], data["yPos"])
				PlayerStats.AllPlayerStats = data["AllPlayerStats"]
				PlayerStats.Beans = data["Beans"]
				level = data["Level"]
				LevelMan.PersistenceKeys = data["PKeys"]
				PlayerStats.Chip = data["Chip"]
				ToastEventMan.Toast = data["Toast"]
			file.close()
			if level and ResourceLoader.exists(level):
				get_tree().change_scene_to_file(level)
				await SignalMan.SceneChanged
				for x in get_tree().get_nodes_in_group("players"):
					x.position = loadPos 

func AndroidSave(data, fileName):
	var fullPath = AndroidSaveDirectory + fileName
	if !DirAccess.dir_exists_absolute(AndroidSaveDirectory):
		var error = DirAccess.make_dir_recursive_absolute(AndroidSaveDirectory)
		if error == OK:
			print("created Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
		else:
			print("Failed to create Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS))
	var file = FileAccess.open(fullPath, FileAccess.WRITE)
	if file:
		file.store_string(data)
		file.close()
		print("Saved the game in ", AndroidSaveDirectory)

func AndroidFileGet(FileName):
	return FileAccess.open(AndroidSaveDirectory + FileName, FileAccess.READ_WRITE)

func AndroidFileExists(FileName):
	if FileAccess.file_exists(AndroidSaveDirectory + FileName):
		return true
	return false
