extends Node

var Achievements := []
var AchievementsToShow := []
var AchievementSound = "res://Assets/Audio/SFX/souAch.wav"
var CanPlayerGetAchievements = true

func _ready() -> void:
	LoadAchievements()

func AddAchievement(Ach: String) -> void:
	if !Achievements.has(Ach) and !PlayerStats.DebugMode and CanPlayerGetAchievements:
		Achievements.append(Ach)
		AchievementsToShow.append(Ach)
		SaveAchievements()
		SignalMan.emit_signal("UpdateAchievements")

func SaveAchievements():
	var data = {
		"Achievements": Achievements
	}
	var encodedString = SaveMan.Encode(data)
	if LevelMan.Os != "Android":
		var file = FileAccess.open("user://Achievements.bj", FileAccess.WRITE)
		file.store_string(encodedString)
		file.close()
	else:
		SaveMan.AndroidSave(encodedString, "Achievements.bj")

func LoadAchievements():
	if FileAccess.file_exists("user://Achievements.bj") and LevelMan.Os != "Android" or LevelMan.Os == "Android" and SaveMan.AndroidFileExists("Achievements.bj"):
		var file
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://Achievements.bj", FileAccess.READ)
		else:
			file = SaveMan.AndroidFileGet("Achievements.bj")
		if file != null:
			var data = SaveMan.DecodeAndParse(file.get_as_text())
			if data is Dictionary:
				Achievements = data["Achievements"]
		

func ChangeAchievementSound(soundFilePath) -> void:
	AchievementSound = soundFilePath

func ResetVariablesToDefault(resetAchievements) -> void:
	if resetAchievements:
		Achievements = []
		AchievementsToShow = []
		SignalMan.emit_signal("UpdateAchievements")
	AchievementSound = "res://Assets/Audio/SFX/souAch.wav"
