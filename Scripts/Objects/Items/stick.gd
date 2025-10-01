extends CharacterBody2D

@export var who: String = "Fency"
var player: Node2D
var damage := 20

func _ready() -> void:
	AchievMan.AddAchievement("Stick")
	player = NovaFunc.GetPlayerFromGroup(who)

func _process(_delta: float) -> void:
	if player != null:
		position = player.position
	else:
		queue_free()
	
	if PlayerStats.AllPlayerStats[who]["Stick"] == false:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("takeDamage"):
		body.takeDamage(damage)
	PlayerStats.AllPlayerStats[who]["Stick"] = false
	queue_free()
