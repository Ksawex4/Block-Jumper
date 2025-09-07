extends Node2D

var posVector: Vector2

func _ready() -> void:
	if LevelMan.Os != "Android":
		print("[joystick.gd] Removed beacuse not Android")
		$"..".queue_free()

func _process(_delta: float) -> void:
	PlayerStats.JoystickPosVector = posVector
