extends Node

var Paused: bool = false
var Os: String = OS.get_name()
var Is_web: bool = false
var Random_saltniczka := true
var Load_position: Vector2
var Jump_pressed: bool = false # mobile only
var Speedrun_mode := false
var Speedrun_timer := {"Hours": 0, "Minutes": 0, "Seconds": 0.0}
var Killed_bosses: Dictionary = {
	"RatKing": false,
}
var Spared_bosses: Dictionary = {
	"RatKing": false,
}
signal PauseGame()
signal LevelChanged()

func _ready() -> void:
	Is_web = true if OS.get_name() == "Web" else false
	if Is_web:
		Os = "Android" if OS.has_feature("web_android") or OS.has_feature("web_ios") else "Linux"
	process_mode = Node.PROCESS_MODE_ALWAYS


func toggle_pause(pause: bool) -> void:
	Paused = pause
	get_tree().paused = pause


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and get_tree().get_nodes_in_group("pauseMenu").size() != 0:
		emit_signal("PauseGame")
		toggle_pause(true)
	if Speedrun_mode and AchievMan.Achievements.size() >= AchievMan.Amount_of_achievements:
		Speedrun_mode = false
	
	if Speedrun_mode:
		Speedrun_timer["Seconds"] += delta
		if Speedrun_timer["Seconds"] >= 60:
			Speedrun_timer["Seconds"] -= 60
			Speedrun_timer["Minutes"] += 1
		if Speedrun_timer["Minutes"] >= 60:
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
	var data: Dictionary = SaveMan.get_data_from_file("Save.bj")
	if data and BobMan.Saved_bobs <= 0:
		var level: String
		if data["PlayerStats"]:
			PlayerStats.load_save_data(data["PlayerStats"])
			Load_position.x = data.get("xPos", 0.0)
			Load_position.y = data.get("yPos", 0.0)
			PlayerStats.Beans = int(data.get("Beans", 0))
			level = data.get("Level", null)
			PlayerStats.Chip = data.get("Chip", false)
			ToastEventMan.get_new_event(int(data.get("Toast", -1)))
			PlayerStats.Follow_who = data.get("FollowingWho", PlayerStats.Follow_who)
			_load_bosses(data.get("Killed_bosses"), data.get("Spared_bosses"))
			DebugMan.dprint("[GameMan, load_game] Loaded, ", data)
		
		if level and ResourceLoader.exists(level):
			get_tree().change_scene_to_file(level)
			await LevelChanged
			if Load_position.x and Load_position.y:
				for player in get_tree().get_nodes_in_group("players"):
					player.position = Load_position


func _load_bosses(killed: Dictionary, spared: Dictionary) -> void:
	if killed != null:
		for x in killed.keys():
			Killed_bosses.set(x, killed[x])
	
	if spared != null:
		for x in spared.keys():
			Spared_bosses.set(x, spared[x])


func reset_variables_to_default(reset_speedrun: bool=false) -> void:
	Paused = false
	get_tree().paused = false
	Load_position = Vector2.ZERO
	if reset_speedrun:
		Speedrun_timer = {"Hours": 0, "Minutes": 0, "Seconds": 0}
		Random_saltniczka = true
		SaveMan.remove_file("Save.bjSPEED")
		SaveMan.remove_file("Achievements.bjSPEED")
		SaveMan.remove_file("The Bobs have awoken.BOBSPEED")
	for key in Killed_bosses.keys():
		Killed_bosses[key] = false
		Spared_bosses[key] = false


func is_mobile() -> bool:
	return Os == "Android"
