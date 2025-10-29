extends Node

var CanBobsGlitch: bool = false
var CanBobsMoveThings: bool = false
var CanBobsAddVelocity: bool = false
var SavedBobs: int = 0
var BobSpawnYPos: int = 3855977.0
var Done: bool = false
var SpawnedBobs: bool = false
var FailToLoad: bool = false
var CanSpawnBouncy_onurB: bool = false
var CanBobsScale: bool = false
var RandomizeCamZoomTimer := 0.0

func _ready() -> void:
	if LevelMan.Os != "Android" and FileAccess.file_exists("user://The Bobs have awoken.BOB") or LevelMan.Os == "Android" and SaveMan.AndroidFileExists("The Bobs have awoken.BOB"):
		var file: FileAccess
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.READ_WRITE)
		else:
			file = SaveMan.AndroidFileGet("The Bobs have awoken.BOB")
		if file:
			var data: Dictionary = SaveMan.DecodeAndParse(file.get_as_text())
			SavedBobs = data["Bob"]
			if data["Bob"] < -1:
				data = {"Bob": -1}
				var encodedData: String = SaveMan.Encode(data)
				file.store_string(encodedData)
			file.close()
			print("[BobManager.gd] Loaded bobs from file, data: ", data)
			if SavedBobs < 0:
				AchievMan.AddAchievement("BOB")
	SignalMan.connect("ChangedLevel", Callable(self, "Undone"))
	print("[BobManager.gd] Loaded")

func _process(_delta: float) -> void:
	CheckIfShouldSpawnBob()
	if !SpawnedBobs and SavedBobs != 8:
		SpawnBobsFromSave()
	if SavedBobs >= 1:
		LevelMan.CanPlayerSave = false
		AchievMan.CanPlayerGetAchievements = false
		BobSpawnYPos *= 0.4
	if SavedBobs >= 2:
		CanBobsGlitch = true
	if SavedBobs >= 3:
		CanBobsMoveThings = true
	if SavedBobs >= 4:
		CanBobsAddVelocity = true
	if SavedBobs >= 5 and RandomizeCamZoomTimer <= 0.0:
		RandomizeCamZoomTimer = randf_range(8.0, 15.0)
		LevelMan.CamZoom = Vector2(randf_range(0.2, 5.0), randf_range(0.2, 5.0))
	if RandomizeCamZoomTimer > 0.0:
		RandomizeCamZoomTimer -= 0.1
	if SavedBobs >= 6 and SavedBobs != 8 and SavedBobs != 9:
		AudioServer.set_bus_effect_enabled(0, 0, true)
	if SavedBobs >= 7:
		CanBobsScale = true
	if SavedBobs == 8:
		Bob8()
	if SavedBobs == 9:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		RemoveEveryPlayerExceptFency()
		RemoveEveryEnemy()
		RemoveEveryNPC()
	if SavedBobs >= 10:
		RemoveEveryPlayerExceptFency()
		CanSpawnBouncy_onurB = true
	if SavedBobs == 11:
		FailToLoad = true

func ResetVariablesToDefault() -> void:
	CanBobsGlitch = false
	CanBobsMoveThings = false
	CanBobsAddVelocity = false
	SavedBobs = 0
	if LevelMan.Os != "Android" and FileAccess.file_exists("user://The Bobs have awoken.BOB") or LevelMan.Os == "Android" and SaveMan.AndroidFileExists("The Bobs have awoken.BOB"):
		var file: FileAccess
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.READ)
		else:
			file = SaveMan.AndroidFileGet("The Bobs have awoken.BOB")
		if file:
			var data: Dictionary = SaveMan.DecodeAndParse(file.get_as_text())
			SavedBobs = data["Bob"]
			file.close()
			if SavedBobs == -999:
				AchievMan.AddAchievement("BOB")
	BobSpawnYPos = 3855977
	Done = false
	SpawnedBobs = false
	FailToLoad = false
	CanSpawnBouncy_onurB = false
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)
	print("[BobManager.gd] Reseted variables and unmutted AudioServer")

func SaveBobs() -> void:
	var data: Dictionary = {"Bob": SavedBobs + 1}
	var encodedData: String = SaveMan.Encode(data)
	if LevelMan.Os != "Android":
		var file: FileAccess = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.WRITE)
		file.store_string(encodedData)
		file.close()
	else:
		SaveMan.AndroidSave(encodedData, "The Bobs have awoken.BOB")
	print("[BobManager.gd] Saved Bobs, data: ", data)

func CheckIfShouldSpawnBob() -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players != null and len(players) != 0:
		for player: Node2D in players:
			if player != null:
				if player.position.y >= BobSpawnYPos and SavedBobs >= 0:
					BobSpawnYPos = 999999999999999
					AddBobAndEnd()
					break
				elif player.position.y >= BobSpawnYPos * 1.5 and get_tree().current_scene.scene_file_path.get_file() != "the_void_lands.tscn":
					LevelMan.ChangeLevel("the_void_lands")
					AchievMan.AddAchievement("TheVoidLands")
				elif player.position.y >= BobSpawnYPos * 0.5 and get_tree().current_scene.scene_file_path.get_file() == "the_void_lands.tscn":
					LevelMan.ChangeLevel("title_screen")

func AddBobAndEnd() -> void:
	if SavedBobs == 0:
		AchievMan.SaveAchievements()
	SaveBobs()
	get_tree().paused = true
	var sound: Resource = preload("uid://la1lof170xpm")
	var audioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sound
	audioPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(audioPlayer)
	audioPlayer.play()
	print("[BobManager.gd] Started Fake Game Freeze")
	await get_tree().create_timer(1.2, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/boot_screen.tscn")
	print("[BobManager.gd] Finished Fake Game Freeze and changed scene to boot_screen.tscn")
	ResetVariablesToDefault()

func Bob8() -> void:
	if !Done and get_tree().current_scene:
		Done = true
		print("[BobManager.gd] Bob6 started successfully")
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
					print("[BobManager.gd] Bob6 finished")

func Undone() -> void:
	Done = false
	SpawnedBobs = false

func RemoveEveryPlayerExceptFency() -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players and players.size() != 1:
		for player: Node2D in players:
			if player.name != "Fency":
				player.queue_free()
		print("[BobManager.gd] Deleted all players except Fency")

func RemoveEveryEnemy() -> void:
	var enemies: Array =  get_tree().get_nodes_in_group("enemies")
	var trashCans: Array = get_tree().get_nodes_in_group("trash_cans")
	if enemies and enemies != []:
		for enemy: Node2D in enemies:
			enemy.queue_free()
		print("[BobManager.gd] Deleted all Enemies")
	if trashCans and trashCans != []:
		for trash: Node2D in trashCans:
			trash.queue_free()
		print("[BobManager.gd] Deleted all Trash Cans")
	

func RemoveEveryNPC() -> void:
	var npcs: Array = get_tree().get_nodes_in_group("npcs")
	if npcs and npcs != []:
		for npc: Node2D in npcs:
			npc.queue_free()
		print("[BobManager.gd] Deleted all NPCs")

func SpawnBobsFromSave() -> void:
	SpawnedBobs = true
	var spawnedBobs: int = 0
	if get_tree().current_scene and get_tree().current_scene.scene_file_path.get_file() != "boot_screen.tscn":
		while spawnedBobs < SavedBobs:
			get_tree().current_scene.add_child(preload("uid://cgr5yq0b3lq60").instantiate())
			spawnedBobs += 1
