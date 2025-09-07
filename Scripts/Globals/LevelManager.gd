extends Node

var Gravity: float = 600.0
var PersistenceKeys: Array = []
var BeansAreToasts: bool = false
var CanPlayerSave: bool = true
var FlyingThingAlive: bool = false
var Os: String = OS.get_name() # Android, Windows, Linux

func _ready() -> void:
	SignalMan.connect("ChangedLevel", Callable(self, "OnLevelChanged"))
	print("[LevelManager.gd] Loaded")

func ChangeLevel(path: String) -> void:
	get_tree().call_deferred("change_scene_to_file", path)
	print("[LevelManager.gd] Changed level to '", path, "'
	===== LEVEL ", path.get_file().get_basename(), " =====")

func ResetVariablesToDefault() -> void:
	Gravity = 600.0
	PersistenceKeys = []
	BeansAreToasts = false
	CanPlayerSave = true
	print("[LevelManager.gd] Reseted variables")

func OnLevelChanged() -> void:
	if FlyingThingAlive and get_tree().current_scene.scene_file_path.get_file() != "title_screen.tscn":
		var FlyingThing: Node2D = load("res://Scenes/Characters/Enemies/flying_thing.tscn").instantiate()
		FlyingThing.position = Vector2(0,0)
		get_tree().current_scene.call_deferred("add_child", FlyingThing)
