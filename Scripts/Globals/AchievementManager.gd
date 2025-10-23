extends Node

var Achievements: Array = []
var AchievementsToShow: Array = []
var AchievementSound: String = "res://Assets/Audio/SFX/sfxAch.wav"
var CanPlayerGetAchievements: bool = true
var AmountOfAchievements: int = 9                                   

func _ready() -> void:
	LoadAchievements()
	print("[AchievementManager.gd] Loaded")

func AddAchievement(Ach: String) -> void:
	if !Achievements.has(Ach) and !PlayerStats.DebugMode and CanPlayerGetAchievements:
		Achievements.append(Ach)
		AchievementsToShow.append(Ach)
		print("[AchievementManager.gd] Added Achievement '", Ach, "'")
		SignalMan.emit_signal("UpdateAchievements")

func SaveAchievements() -> void:
	var data: Dictionary = {
		"Achievements": Achievements
	}
	var encodedString: String = SaveMan.Encode(data)
	if LevelMan.Os != "Android":
		var file: FileAccess = FileAccess.open("user://Achievements.bj", FileAccess.WRITE)
		file.store_string(encodedString)
		file.close()
		print("[AchievementsManager.gd] Saved Achievements '", data, "' as Achievements.bj")
	else:
		SaveMan.AndroidSave(encodedString, "Achievements.bj")

func LoadAchievements() -> void:
	if !PlayerStats.SpeedrunMode and FileAccess.file_exists("user://Achievements.bj") and LevelMan.Os != "Android" or LevelMan.Os == "Android" and SaveMan.AndroidFileExists("Achievements.bj"):
		var file: FileAccess
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://Achievements.bj", FileAccess.READ)
		else:
			file = SaveMan.AndroidFileGet("Achievements.bj")
		if file != null:
			var data: Dictionary = SaveMan.DecodeAndParse(file.get_as_text())
			Achievements = data["Achievements"]
			print("[AchievementManager.gd] Loaded Achievements '", data, "' from Achievements.bj")
		

func ChangeAchievementSound(soundFilePath: String) -> void:
	AchievementSound = soundFilePath
	print("[AchievementManager.gd] Changed achievement sound to '", soundFilePath, "'")

func ResetVariablesToDefault(resetAchievements: bool=false) -> void:
	if resetAchievements:
		Achievements = []
		AchievementsToShow = []
		SignalMan.emit_signal("UpdateAchievements")
		print("[AchievementManager.gd] Reseted Achievements")
	AchievementSound = "res://Assets/Audio/SFX/sfxAch.wav"
	print("[AchievementManager.gd] Reseted Achievement Sound")
