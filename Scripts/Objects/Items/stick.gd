extends CharacterBody2D

@export var who: String = "Fency"
var player: Node2D

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
	var bodyBaseName: String = body.get_scene_file_path().get_file().get_basename()
	if bodyBaseName == "kill_block":
		AchievMan.AddAchievement("BlockKiller")
		print("[stick.gd, ", player.name, "] Killed a killblock")
	if bodyBaseName == "spamguy":
		AchievMan.AddAchievement("SpamKiller")
		print("[stick.gd, ", player.name, "] Killed a spamkiller")
	if bodyBaseName == "flying_thing":
		AchievMan.AddAchievement("Saltiest")
		print("[stick.gd, ", player.name, "] Salt will appear in next level")
	if body.has_meta("instanceID"):
		var instanceId: String = body.get_meta("instanceID")
		LevelMan.PersistenceKeys.append(instanceId)
	if !bodyBaseName.begins_with("boss"):
		body.queue_free()
	else:
		body.health -= 20
	PlayerStats.AllPlayerStats[who]["Stick"] = false
	queue_free()
