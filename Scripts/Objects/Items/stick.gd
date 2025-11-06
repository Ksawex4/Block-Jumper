extends CharacterBody2D

@export var Who: String = ""
@export var No_player := false
var Stick_type := "Normal"
var Player: Node2D
var Damage := 40

func _ready() -> void:
	Player = NovaFunc.GetPlayerFromGroup(Who)
	if No_player:
		set_collision_mask_value(1, true)
	elif not No_player and Who != "":
		Stick_type = PlayerStats.AllPlayerStats[Who]["StickType"]
	
	match Stick_type:
		"Normal": pass
		"Cheese":
			Damage = 20
			$Sprite2D.texture = preload("uid://bln2uwbsqudqs")


func _process(_delta: float) -> void:
	if not No_player and Who != "":
		if Player != null:
			position = Player.position
		else:
			queue_free()
		if PlayerStats.AllPlayerStats[Who]["Stick"] == false:
			queue_free()


func _physics_process(delta: float) -> void:
	if No_player:
		if not is_on_floor():
			velocity.y += LevelMan.Gravity * delta
		move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not No_player and Who != "":
		if (
		body.has_method("takeDamage") and not body.name.begins_with("Boss") 
		or body.name.begins_with("Boss") and LevelMan.BossFightOn
		):
			body.takeDamage(Damage)
			PlayerStats.AllPlayerStats[Who]["Stick"] = false
			queue_free()


func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if not PlayerStats.AllPlayerStats[body.name]["Stick"] and Who == "":
		AchievMan.AddAchievement("Stick")
		Who = body.whoAmI
		Player = body
		set_collision_mask_value(1, false)
		PlayerStats.AllPlayerStats[body.name]["Stick"] = true
		PlayerStats.AllPlayerStats[body.name]["StickType"] = Stick_type
		No_player = false
