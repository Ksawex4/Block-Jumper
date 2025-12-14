extends Node

var Gravity: float = 10.0
var Spawn_flying_thing := false
var Cam_zoom = Vector2(1.0, 1.0)
var Can_player_save := true
var Boss_fight := false
var Boss_cam_pos := Vector2.ZERO
var Can_quit_level := true


func _ready() -> void:
	GameMan.connect("LevelChanged", Callable(self, "_on_level_changed"))


func change_level(level_name: String, path: String="res://Scenes/Levels/") -> void:
	if Can_quit_level:
		var level_path = path + level_name
		get_tree().call_deferred("change_scene_to_file", level_path)
		DebugMan.dprint("===== Changed level to ", level_name, " ===== [LevelMan]")


func _on_level_changed() -> void:
	if Spawn_flying_thing == true and get_tree().current_scene.scene_file_path.get_file() != "title_screen.tscn":
		var FlyingThing: Node2D = preload("uid://bvptmfk8ofbv7").instantiate()
		FlyingThing.position = Vector2(0,0)
		get_tree().current_scene.call_deferred("add_child", FlyingThing)


func load_level_vars(gravity: float, cam_zoom: Vector2) -> void:
	Gravity = gravity if gravity else 10.0
	Cam_zoom = cam_zoom if cam_zoom else Cam_zoom
	DebugMan.dprint("[LevelMan, load_level_vars] Loaded ", Gravity, Cam_zoom)


func reset_variables_to_default(reset_flying: bool=false) -> void:
	Gravity = 10.0
	Cam_zoom = Vector2(1.0, 1.0)
	Can_player_save = true
	Boss_fight = false
	Boss_cam_pos = Vector2.ZERO
	if reset_flying:
		Spawn_flying_thing = false
	DebugMan.dprint("[LevelMan, reset_variables_to_default] done ", reset_flying)
