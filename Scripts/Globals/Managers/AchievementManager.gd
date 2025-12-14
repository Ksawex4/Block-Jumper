extends Node

var Achievements: Array = []
var Achievements_to_show: Array = []
var Achievement_sound: String = "res://Assets/Audio/SFX/sfxAch.wav"
var Can_get_achievements: bool = true
var Achievement_sprites: Dictionary[String, Resource] = {
	"BlockKiller": preload("uid://nxjjgryjmpma"),
	"BOB": preload("uid://btp1mdhxrxjgg"),
	"Chip": preload("uid://tjph8wskgfw3"),
	"ParkourGuy": preload("uid://c6h8hibkf3l27"),
	"Saltiest": preload("uid://b0jxufbmyeiwf"),
	"SpamKiller": preload("uid://b0qf444yhoidh"),
	"Stick": preload("uid://cocmwte1f4fv7"),
	"TheRatKing": preload("uid://b6p1au4f06awe"),
	"TheVoidLands": preload("uid://de1kpksohy5gn"),
	"Trash": preload("uid://b5o8xs53lomxl"),
}
var Amount_of_achievements: int = Achievement_sprites.size()
signal ShowAchievements()
signal UpdateAchievements()


func add_achievement(achievement: String) -> void:
	if achievement not in Achievements:
		Achievements.append(achievement)
		Achievements_to_show.append(achievement)
		emit_signal("UpdateAchievements")
		save_achievements()
		DebugMan.dprint("[AchievMan, add_achievement] Added ", achievement)


func has_achievement(achievement: String) -> bool:
	return Achievements.has(achievement)


func change_achievement_sound(path: String) -> void:
	if FileAccess.file_exists(path):
		Achievement_sound = path
		DebugMan.dprint("[AchievMan, change_achievement_sound] changed to ", path)
	else:
		push_warning("File doesn't exist! ", path)


func save_achievements() -> void:
	var data := {
		"Achievements": Achievements,
		"Achievements_to_show": Achievements_to_show,
	}
	SaveMan.save_file("Achievements.bj", data)
	DebugMan.dprint("[AchievMan, save_achievements] Saved")


func load_achievements() -> void:
	var data := SaveMan.get_data_from_file("Achievements.bj")
	if data:
		Achievements = data.get("Achievements", [])
		Achievements_to_show = data.get("Achievements_to_show", [])
		DebugMan.dprint("[AchievMan, load_achievements] Loaded")


func reset_variables_to_default(reset_achievements: bool =false) -> void:
	Achievements = [] if reset_achievements else Achievements
	Achievements_to_show = []
	Achievement_sound = "res://Assets/Audio/SFX/sfxAch.wav"
	Can_get_achievements = true
	emit_signal("UpdateAchievements")
	DebugMan.dprint("[AchievMan, reset_variables_to_default] done")
