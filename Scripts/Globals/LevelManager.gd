extends Node

var Gravity = 600.0
var PersistenceKeys = []
var BeansAreToasts = false
var CanPlayerSave = true
var FlyingThingAlive = false
var Os = OS.get_name() # Android, Windows, Linux

func _ready() -> void:
	SignalMan.connect("ChangedLevel", Callable(self, "OnLevelChanged"))

func ChangeLevel(path: String):
	get_tree().call_deferred("change_scene_to_file", path)

func ResetVariablesToDefault() -> void:
	Gravity = 600.0
	PersistenceKeys = []
	BeansAreToasts = false
	CanPlayerSave = true

func OnLevelChanged() -> void:
	if FlyingThingAlive and get_tree().current_scene.scene_file_path.get_file() != "title_screen.tscn":
		var FlyingThing = load("res://Scenes/Characters/Enemies/flying_thing.tscn").instantiate()
		FlyingThing.position = Vector2(0,0)
		get_tree().current_scene.call_deferred("add_child", FlyingThing)
