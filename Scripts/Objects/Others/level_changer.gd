extends Area2D

@export var LevelPath: String = "res://Scenes/boot_screen.tscn"

func _on_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name):
		print("[level_changer.gd] Changing level to ", LevelPath)
		LevelMan.ChangeLevel(LevelPath)
