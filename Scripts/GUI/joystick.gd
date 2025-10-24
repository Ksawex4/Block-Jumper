extends Node2D

var posVector: Vector2
var jump: int = 0 # 1 is jumping, 0 is not jumping

func _ready() -> void:
	if LevelMan.Os != "Android":
		print("[joystick.gd] Removed beacuse not Android")
		$"..".queue_free()

func _process(_delta: float) -> void:
	PlayerStats.JoystickPosVector = posVector
	PlayerStats.MobileJump = jump


func _on_jump_button_pressed() -> void:
	jump = 1


func _on_jump_button_released() -> void:
	jump = 0
