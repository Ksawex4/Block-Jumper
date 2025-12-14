extends Node

var Paused: bool = false
var Os: String = OS.get_name()
var Random_saltniczka := true
var Load_position: Vector2
var Jump_pressed: bool = false # mobile only
var Speedrun_mode := false
var Speedrun_timer := {"Hours": 0, "Minutes": 0, "Seconds": 0, "Frames": 0}
var Killed_bosses: Dictionary = {
	"RatKing": false,
}
var Spared_bosses: Dictionary = {
	"RatKing": false,
}
signal PauseGame()
signal LevelChanged()


func toggle_pause(pause: bool) -> void:
	Paused = pause
	get_tree().paused = pause


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and get_tree().get_nodes_in_group("pauseMenu").size() != 0:
		emit_signal("PauseGame")
		toggle_pause(true)


func _physics_process(_delta: float) -> void:
	if Speedrun_mode and AchievMan.Achievements.size() >= AchievMan.Amount_of_achievements-1:
		Speedrun_mode = false
	if Speedrun_mode:
		Speedrun_timer["Frames"] += 1
		if Speedrun_timer["Frames"] >= 60:
			Speedrun_timer["Frames"] -= 60
			Speedrun_timer["Seconds"] += 1
		if Speedrun_timer["Seconds"] >= 60:
			Speedrun_timer["Seconds"] -= 60
			Speedrun_timer["Minutes"] += 1
		if Speedrun_timer["Minutes"] >= 60:
			Speedrun_timer["Minutes"] -= 60
			Speedrun_timer["Hours"] += 1


func save_game(position) -> void:
	var data: Dictionary = {
		"Version": SaveMan.Game_version,
		"xPos": position.x,
		"yPos": position.y,
		"PlayerStats": PlayerStats.get_save_data(),
		"Beans": PlayerStats.Beans,
		"Level": get_tree().current_scene.scene_file_path,
		"Chip": PlayerStats.Chip,
		"Toast": ToastEventMan.Toast,
		"FollowingWho": PlayerStats.Follow_who,
		"Killed_bosses": Killed_bosses,
		"Spared_bosses": Spared_bosses,
	}
	SaveMan.save_file("Save.bj", data)
	DebugMan.dprint("[GameMan, save_game] Saved")


func load_game() -> void:
	var data = SaveMan.get_data_from_file("Save.bj")
	if data and BobMan.Saved_bobs <= 0:
		var level: String
		if data["PlayerStats"]:
			PlayerStats.load_save_data(data["PlayerStats"])
			Load_position.x = data["xPos"] if data["xPos"] else 0.0
			Load_position.y = data["yPos"] if data["yPos"] else 0.0
			PlayerStats.Beans = data["Beans"] if data["Beans"] else 0
			level = data["Level"] if data["Level"] else null
			PlayerStats.Chip = data["Chip"] if data["Chip"] else false
			ToastEventMan.get_new_event(int(data["Toast"]) if int(data["Toast"]) else -1)
			PlayerStats.Follow_who = data["FollowingWho"] if data["FollowingWho"] else PlayerStats.Follow_who
			Killed_bosses = data["Killed_bosses"] if data["Killed_bosses"] else Killed_bosses
			Spared_bosses = data["Spared_bosses"] if data["Spared_bosses"] else Killed_bosses
			DebugMan.dprint("[GameMan, load_game] Loaded, ", data)
		
		if level and ResourceLoader.exists(level):
			get_tree().change_scene_to_file(level)
			await LevelChanged
			if Load_position.x and Load_position.y:
				for player in get_tree().get_nodes_in_group("players"):
					player.position = Load_position


func reset_variables_to_default() -> void:
	Paused = false
	get_tree().paused = false
	Random_saltniczka = true
	Load_position = Vector2.ZERO
	Speedrun_timer = {"Hours": 0, "Minutes": 0, "Seconds": 0, "Frames": 0}
	for key in Killed_bosses.keys():
		Killed_bosses[key] = false
		Spared_bosses[key] = false


func is_mobile() -> bool:
	return Os == "Android"
