extends Node

var Gravity: float = 600.0
var PersistenceKeys: Array = []
var BeansAreToasts: bool = false
var CanPlayerSave: bool = true
var FlyingThingAlive: bool = false
var Os: String = OS.get_name() # Android, Windows, Linux
var SpeedrunTimer: Dictionary = {"Hours": 0, "Minutes": 0, "Seconds": 0, "Frames": 0}
var LevelPath: String = "res://Scenes/Levels/LEVELL.tscn"
var BossFightOn := false
var BossCamPos := Vector2(0,0)
var CamZoom := Vector2(1,1)

func _ready() -> void:
	SignalMan.connect("ChangedLevel", Callable(self, "OnLevelChanged"))
	print("[LevelManager.gd] Loaded")
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta: float) -> void:
	if PlayerStats.SpeedrunMode and AchievMan.Achievements.size() < AchievMan.AmountOfAchievements:
		SpeedrunTimer["Frames"] += 1
	if SpeedrunTimer["Frames"] >= 60:
		SpeedrunTimer["Frames"] -= 60
		SpeedrunTimer["Seconds"] += 1
	if SpeedrunTimer["Seconds"] >= 60:
		SpeedrunTimer["Seconds"] -= 60
		SpeedrunTimer["Minutes"] += 1
	if SpeedrunTimer["Minutes"] >= 60:
		SpeedrunTimer["Minutes"] -= 60
		SpeedrunTimer["Hours"] += 1

func ChangeLevel(levelName: String) -> void:
	get_tree().call_deferred("change_scene_to_file", LevelPath.replace("LEVELL", levelName))
	print("[LevelManager.gd] Changed level to '", LevelPath.replace("LEVELL", levelName), "'
	===== LEVEL ", levelName, " =====")
	BossFightOn = false

func ResetVariablesToDefault() -> void:
	Gravity = 600.0
	PersistenceKeys = []
	BeansAreToasts = false
	CanPlayerSave = true
	print("[LevelManager.gd] Reseted variables")
	BossFightOn = false

func OnLevelChanged() -> void:
	if FlyingThingAlive and get_tree().current_scene.scene_file_path.get_file() != "title_screen.tscn":
		var FlyingThing: Node2D = preload("uid://bvptmfk8ofbv7").instantiate()
		FlyingThing.position = Vector2(0,0)
		get_tree().current_scene.call_deferred("add_child", FlyingThing)
