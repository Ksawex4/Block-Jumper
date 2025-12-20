extends Node

var Saved_bobs := 0
var Can_glitch: bool = false
var Can_spin: bool = false
var Can_add_velocity: bool = false
var Can_spawn_bouncy: bool = false
var Can_scale: bool = false
var Bob_spawn_y_pos := 3855977.0
const END_BOBS: int = 11
var Done := false
var Spawned_bobs := false
var Fail_to_load := false
var Cam_zoom_timer := 0.0


func _ready() -> void:
	load_bobs_from_filah()
	GameMan.connect("LevelChanged", Callable(self, "undone"))
	DebugMan.dprint("[BobMan , _ready] done")


func _process(_delta: float) -> void:
	bob_check()
	if not Spawned_bobs and Saved_bobs != 9:
		spawn_bobs()
	if Saved_bobs >= 1:
		LevelMan.Can_player_save = false
		AchievMan.Can_get_achievements = false
		Bob_spawn_y_pos = 385597.0
	
	Can_glitch = true if Saved_bobs >= 2 else false
	Can_spin = true if Saved_bobs >= 3 else false
	Can_add_velocity = true if Saved_bobs >= 4 else false
	Can_scale= true if Saved_bobs >= 7 else false
	Can_spawn_bouncy = true if Saved_bobs >= 10 else false
	Fail_to_load = true if Saved_bobs == 11 else false
	
	if Saved_bobs >= 5 and Cam_zoom_timer <= 0.0:
		Cam_zoom_timer = randf_range(8.0, 15.0)
		LevelMan.Cam_zoom = Vector2(randf_range(0.3, 3.0), randf_range(0.3, 3.0))
	if Cam_zoom_timer > 0.0:
		Cam_zoom_timer -= 0.1
	
	if Saved_bobs >= 6 and Saved_bobs != 8 and Saved_bobs != 9:
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true)
	
	if Saved_bobs == 8:
		bob8()
	
	if Saved_bobs == 9:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		remove_every_player_except_fency()
		remove_every_enemy()
		remove_every_npc()
	
	if Saved_bobs >= 10:
		remove_every_player_except_fency()


func bob_check() -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players:
		for player: CharacterBody2D in players:
			if player != null:
				var current_level_scene_path := get_tree().current_scene.scene_file_path.get_file()
				if player.position.y >= Bob_spawn_y_pos and Saved_bobs >= 0:
					Bob_spawn_y_pos = INF
					add_bob_and_end()
					break
				elif player.position.y >= Bob_spawn_y_pos * 1.5 and current_level_scene_path != "the_void_lands.tscn":
					LevelMan.change_level("the_void_lands.tscn")
					AchievMan.add_achievement("TheVoidLands")
					DebugMan.dprint("[BobMan , bob_check] Changed level, ", player.position.y)
					break
				elif player.position.y >= Bob_spawn_y_pos * 0.4 and current_level_scene_path == "the_void_lands.tscn":
					LevelMan.change_level("the_void_lands.tscn")
					DebugMan.dprint("[BobMan , bob_check] reloaded level, ", player.position.y)
					break


func save_bobs() -> void:
	var data := {
		"BOB": Saved_bobs + 1,
	}
	if Saved_bobs + 1 > END_BOBS:
		data["BOB"] = -999
	SaveMan.save_file("The Bobs have awoken.BOB", data)
	DebugMan.dprint("[BobMan, save_bobs] Saved")


func add_bob_and_end() -> void:
	if Saved_bobs == 0:
		AchievMan.save_achievements()
	save_bobs()
	get_tree().paused = true
	DebugMan.dprint("[BobMan, add_bob_and_end] Fake crash")
	crash_bob()


func crash_bob() -> void:
	var sound: Resource = preload("uid://la1lof170xpm")
	var audioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sound
	audioPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(audioPlayer)
	audioPlayer.play()
	print("[BobManager.gd] Started Fake Game Freeze")
	await get_tree().create_timer(1.2).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/boot_screen.tscn")
	DebugMan.dprint("[BobMan, crash_bob] Fake crashed")


func undone() -> void:
	Done = false
	Spawned_bobs = false


func spawn_bobs() -> void:
	Spawned_bobs = true
	var spawned_bobs := 0
	var bob := preload("uid://cgr5yq0b3lq60")
	if get_tree().current_scene and get_tree().current_scene.scene_file_path.get_file() != "boot_screen.tscn":
		while spawned_bobs < Saved_bobs:
			get_tree().current_scene.add_child(bob.instantiate())
			spawned_bobs += 1


func load_bobs_from_filah() -> void:
	var data := SaveMan.get_data_from_file("The Bobs have awoken.BOB")
	if data:
		Saved_bobs = int(data.get("BOB", 0))
		if Saved_bobs < 0:
			Saved_bobs = -1
			await get_tree().create_timer(1.0).timeout
			AchievMan.add_achievement("BOB")
		DebugMan.dprint("[BobMan, load_bobs_from_filah] Loaded, ", Saved_bobs)


func bob8() -> void:
	if not Done and get_tree().current_scene:
		Done = true
		var songs: Array = ["musMainMenu.ogg", "musTrash.ogg", "musZworkaSong.ogg", "musNewbob.ogg", "musSewerSong.ogg", "musBigcheese.ogg"]
		if len(songs) != 0:
			for song: String in songs:
				var path: String = "res://Assets/Audio/Music/" + song
				var streamer: Resource = load(path)
				if streamer:
					var audiPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
					audiPlayer.stream = streamer
					audiPlayer.autoplay = true
					audiPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
					get_tree().current_scene.add_child(audiPlayer)
					audiPlayer.play()

func reset_variables_to_default() -> void:
	Saved_bobs = 0
	Can_glitch = false
	Can_spin = false
	Can_add_velocity = false
	Can_spawn_bouncy = false
	Can_scale = false
	Bob_spawn_y_pos = 3855977.0
	load_bobs_from_filah()
	undone()
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false)
	DebugMan.dprint("[BobMan, reset_variables_to_default] done")


func remove_every_player_except_fency() -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players and players.size() != 1:
		for player: Node2D in players:
			if player.name != "Fency":
				player.queue_free()


func remove_every_enemy() -> void:
	var enemies: Array =  get_tree().get_nodes_in_group("enemies")
	var trashCans: Array = get_tree().get_nodes_in_group("trash_cans")
	if enemies and enemies != []:
		for enemy: Node2D in enemies:
			enemy.queue_free()
	if trashCans and trashCans != []:
		for trash: Node2D in trashCans:
			trash.queue_free()


func remove_every_npc() -> void:
	var npcs: Array = get_tree().get_nodes_in_group("npcs")
	if npcs and npcs != []:
		for npc: Node2D in npcs:
			npc.queue_free()
