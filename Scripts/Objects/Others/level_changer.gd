extends Area2D

@export var LevelPath = "res://Scenes/boot_screen.tscn"

func _on_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name):
		LevelMan.ChangeLevel(LevelPath)
