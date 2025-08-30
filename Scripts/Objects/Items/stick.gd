extends CharacterBody2D

@export var who = "Fency"
var player

func _ready():
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
	var bodyBaseName = body.get_scene_file_path().get_file().get_basename()
	if bodyBaseName == "kill_block":
		AchievMan.AddAchievement("BlockKiller")
	if bodyBaseName == "spamguy":
		AchievMan.AddAchievement("SpamKiller")
	if bodyBaseName == "flying_thing":
		AchievMan.AddAchievement("Saltiest")
		print("salt will appear in next level")
	if body.has_meta("instanceID"):
		var instanceId = body.get_meta("instanceID")
		LevelMan.PersistenceKeys.append(instanceId)
	body.queue_free()
	PlayerStats.AllPlayerStats[who]["Stick"] = false
	queue_free()
