extends Node

var CanBobsGlitch := false
var CanBobsMoveThings := false
var CanBobsAddVelocity := false
var SavedBobs = 0
var BobSpawnYPos = 3855977
var Done = false
var SpawnedBobs = false
var FailToLoad = false
var CanSpawnBouncy_onurB = false
var CanBobsScale = false

func _ready() -> void:
	if LevelMan.Os != "Android" and FileAccess.file_exists("user://The Bobs have awoken.BOB") or LevelMan.Os == "Android" and SaveMan.AndroidFileExists("The Bobs have awoken.BOB"):
		var file
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.READ)
		else:
			file = SaveMan.AndroidFileGet("The Bobs have awoken.BOB")
		if file:
			var data = SaveMan.DecodeAndParse(file.get_as_text())
			SavedBobs = data["Bob"]
			file.close()
			if SavedBobs == -999:
				AchievMan.AddAchievement("BOB")
	SignalMan.connect("ChangedLevel", Callable(self, "Undone"))

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
				var music = get_tree().current_scene.get_node("AudioStreamPlayer")
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
		var file
		if LevelMan.Os != "Android":
			file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.READ)
		else:
			file = SaveMan.AndroidFileGet("The Bobs have awoken.BOB")
		if file:
			var data = SaveMan.DecodeAndParse(file.get_as_text())
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

func SaveBobs() -> void:
	var data = {"Bob": SavedBobs + 1}
	var encodedData = SaveMan.Encode(data)
	if LevelMan.Os != "Android":
		var file = FileAccess.open("user://The Bobs have awoken.BOB", FileAccess.WRITE)
		file.store_string(encodedData)
		file.close()
	else:
		SaveMan.AndroidSave(encodedData, "The Bobs have awoken.BOB")

func CheckIfShouldSpawnBob() -> void:
	var players = get_tree().get_nodes_in_group("players")
	if players != null and len(players) != 0:
		for player in players:
			if player != null:
				if player.position.y >= BobSpawnYPos:
					BobSpawnYPos = 999999999999999
					AddBobAndEnd()
					break

func AddBobAndEnd() -> void:
	SaveBobs()
	get_tree().paused = true
	var sound = load("res://Assets/Audio/SFX/souCrash.wav")
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = sound
	audioPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().current_scene.add_child(audioPlayer)
	audioPlayer.play()
	await get_tree().create_timer(1.2, true).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/boot_screen.tscn")
	ResetVariablesToDefault()

func Bob6():
	if !Done and get_tree().current_scene:
		Done = true
		print("worked 1")
		var songs = ["souMainMenu.ogg", "souTrash.ogg", "souZworkaSong.ogg", "sOuZWOrkASOOOOOnG.ogg"]
		print(songs)
		if len(songs) != 0:
			for song in songs:
				var path = "res://Assets/Audio/Music/" + song
				var streamer = load(path)
				if streamer:
					print("worked 2")
					var audiPlayer = AudioStreamPlayer.new()
					audiPlayer.stream = streamer
					audiPlayer.autoplay = true
					audiPlayer.process_mode = Node.PROCESS_MODE_ALWAYS
					get_tree().current_scene.add_child(audiPlayer)
					audiPlayer.play()

func Undone():
	Done = false
	SpawnedBobs = false

func RemoveEveryPlayerExceptFency():
	var players = get_tree().get_nodes_in_group("players")
	if players:
		for player in players:
			if player.name != "Fency":
				player.queue_free()

func RemoveEveryEnemy():
	var enemies =  get_tree().get_nodes_in_group("enemies")
	var trashCans = get_tree().get_nodes_in_group("trash_cans")
	if enemies:
		for enemy in enemies:
			enemy.queue_free()
	if trashCans:
		for trash in trashCans:
			trash.queue_free()

func RemoveEveryNPC():
	var npcs = get_tree().get_nodes_in_group("npcs")
	if npcs:
		for npc in npcs:
			npc.queue_free()

func SpawnBobsFromSave():
	SpawnedBobs = true
	var spawnedBobs = 0
	if get_tree().current_scene and get_tree().current_scene.scene_file_path.get_file() != "boot_screen.tscn":
		while spawnedBobs < SavedBobs:
			get_tree().current_scene.add_child(load("res://Scenes/Characters/NPCs/bob.tscn").instantiate())
			spawnedBobs += 1
