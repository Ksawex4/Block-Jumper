extends Node


@export var LevelInfor: LevelInfo = preload("uid://8xesnpsjxf15")


func _init() -> void:
	if LevelInfo:
		LevelMan.load_level_vars(LevelInfor.Gravity, LevelInfor.Cam_zoom)


func _ready() -> void:
	GameMan.emit_signal("LevelChanged")
	DebugMan.dprint("[level, _ready] Hai")
