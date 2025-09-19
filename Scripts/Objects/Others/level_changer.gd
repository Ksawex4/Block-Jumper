extends Area2D

@export var LevelPath: String = "boot_screen"
@export var ChangeLevel: bool = true
@export var Position: Vector2 = Vector2(0,0)

func _on_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name):
		if ChangeLevel:
			print("[level_changer.gd] Changing level to ", LevelPath)
			LevelMan.ChangeLevel(LevelPath)
		else:
			print("[level_changer.gd] Teleporting Player to ", Position)
			body.position = Position
