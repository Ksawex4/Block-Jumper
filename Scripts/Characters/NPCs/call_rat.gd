extends "res://addons/nova-resource-packs/nodes/texture/NovaSprite2D.gd"


func _on_area_2d_body_entered(_body: Node2D) -> void:
	AchievMan.add_achievement("CallRat")
