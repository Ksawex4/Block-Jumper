extends Node

var Achievements: Array = []
var Achievements_to_show: Array = []
## Id of sfx in NovaAudio
var Achievement_id: StringName = &"sfx-achievement"
var Can_get_achievements: bool = true
## achievement_id: texture_id
var Achievement_sprites: Dictionary[StringName, StringName] = {}
var Amount_of_achievements: int
signal ShowAchievements()
signal UpdateAchievements()


func _ready() -> void:
	var get_data := func get_data() -> Dictionary:
		var data_path: String = "res://Scripts/Globals/Managers/achievements.json"
		if !FileAccess.file_exists(data_path):
			push_warning("achievements.json doesn't exist path: %s " % [data_path])
			return {}
		
		var file: FileAccess = FileAccess.open(data_path, FileAccess.READ)
		var err: Error = FileAccess.get_open_error()
		if err != OK:
			push_warning("Failed to open data.json at %s got error: %s" % [data_path, err])
			return {}
		
		var data: Dictionary = JSON.parse_string(file.get_as_text())
		file.close()
		
		return data
	
	var achiev_data: Dictionary = get_data.call()
	for id: StringName in achiev_data:
		Achievement_sprites.set(id, achiev_data[id])
	Amount_of_achievements = Achievement_sprites.size()


func add_achievement(achievement: String) -> void:
	if achievement not in Achievements:
		Achievements.append(achievement)
		Achievements_to_show.append(achievement)
		emit_signal("UpdateAchievements")
		save_achievements()
		DebugMan.dprint("[AchievMan, add_achievement] Added ", achievement)


func has_achievement(achievement: String) -> bool:
	return Achievements.has(achievement)


func change_achievement_sound(id: String) -> void:
	if NovaAudio.Sfx.has(id):
		Achievement_id = id
		DebugMan.dprint("[AchievMan, change_achievement_sound] changed to ", id)
	else:
		push_warning("id doesn't exist! ", id)


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
	Achievement_id = &"sfx-achievement"
	Can_get_achievements = true
	emit_signal("UpdateAchievements")
	DebugMan.dprint("[AchievMan, reset_variables_to_default] done")
