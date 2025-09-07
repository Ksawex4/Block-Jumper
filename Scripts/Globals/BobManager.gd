extends Node

var CanBobsGlitch: bool = false
var CanBobsMoveThings: bool = false
var CanBobsAddVelocity: bool = false
var SavedBobs: int = 0
var BobSpawnYPos: int = 3855977
var Done: bool = false
var SpawnedBobs: bool = false
var FailToLoad: bool = false
var CanSpawnBouncy_onurB: bool = false
var CanBobsScale: bool = false

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
	if !SpawnedBobs and SavedBobs != 7:
		SpawnBobsFromSave()
	if SavedBobs >= 1:
		LevelMan.CanPlayerSave = false
		AchievMan.CanPlayerGetAchievements = false
		BobSpawnYPos = 385597
	if SavedBobs >= 2:
		CanBobsGlitch = true
	if SavedBobs >= 3:
		CanBobsMoveThings = true
	if SavedBobs >= 4 and SavedBobs != 6 and SavedBobs != 8:
		if get_tree().current_scene != null:
			if get_tree().current_scene.has_node("AudioStreamPlayer"):
				var music: AudioStreamPlayer = get_tree().current_scene.get_node("AudioStreamPlayer")
				if music.stream.resource_path != "res://Assets/Audio/Music/sOuZWOrkASOOOOOnG.ogg":
					music.stream = load("res://Assets/Audio/Music/sOuZWOrkASOOOOOnG.ogg")
					music.play()
	if SavedBobs >= 5:
		CanBobsAddVelocity = true
	if SavedBobs == 6:
		Bob6()
	if SavedBobs == 7:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
		RemoveEveryPlayerExceptFency()
		RemoveEveryEnemy()
		RemoveEveryNPC()
	if SavedBobs >= 8:
		RemoveEveryPlayerExceptFency()
		CanSpawnBouncy_onurB = true
	if SavedBobs >= 9:
		CanBobsScale = true
	if SavedBobs == 10:
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
					LevelMan.ChangeLevel("res://Scenes/Levels/the_void_lands.tscn")
					AchievMan.AddAchievement("TheVoidLands")

func AddBobAndEnd() -> void:
	if SavedBobs == 0:
		AchievMan.SaveAchievements()
	SaveBobs()
	get_tree().paused = true
	var sound: Resource = load("res://Assets/Audio/SFX/souCrash.wav")
	var audioPlayer: AudioStreamPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sound
	audioPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(audioPlayer)
	audioPlayer.play()
	print("[BobManager.gd] Started Fake Game Freeze")
	await get_tree().create_timer(1.2, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/boot_screen.tscn")
	print("[BobManager.gd] Finished Fake Game Freeze and changed scene to boot_screen.tscn")
	ResetVariablesToDefault()

func Bob6() -> void:
	if !Done and get_tree().current_scene:
		print("[BobManager.gd] Bob6 started successfully")
		Done = true
		var songs: Array = ["souMainMenu.ogg", "souTrash.ogg", "souZworkaSong.ogg", "sOuZWOrkASOOOOOnG.ogg", "newbob.ogg"]
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
	if players:
		for player: Node2D in players:
			if player.name != "Fency":
				player.queue_free()
		print("[BobManager.gd] Deleted all players except Fency")

func RemoveEveryEnemy() -> void:
	var enemies: Array =  get_tree().get_nodes_in_group("enemies")
	var trashCans: Array = get_tree().get_nodes_in_group("trash_cans")
	if enemies:
		for enemy: Node2D in enemies:
			enemy.queue_free()
		print("[BobManager.gd] Deleted all Enemies")
	if trashCans:
		for trash: Node2D in trashCans:
			trash.queue_free()
		print("[BobManager.gd] Deleted all Trash Cans")
	

func RemoveEveryNPC() -> void:
	var npcs: Array = get_tree().get_nodes_in_group("npcs")
	if npcs:
		for npc: Node2D in npcs:
			npc.queue_free()
		print("[BobManager.gd] Deleted all NPCs")

func SpawnBobsFromSave() -> void:
	SpawnedBobs = true
	var spawnedBobs: int = 0
	if get_tree().current_scene and get_tree().current_scene.scene_file_path.get_file() != "boot_screen.tscn":
		while spawnedBobs < SavedBobs:
			get_tree().current_scene.add_child(load("res://Scenes/Characters/NPCs/bob.tscn").instantiate())
			spawnedBobs += 1
