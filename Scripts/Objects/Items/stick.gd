extends CharacterBody2D

@export var who: String = ""
@export var noPlayer := false
var stickType = "Normal"
var player: Node2D
var damage := 40

func _ready() -> void:
	player = NovaFunc.GetPlayerFromGroup(who)
	if noPlayer:
		set_collision_mask_value(1, true)
	
	match stickType:
		"Normal": pass
		"Cheese":
			damage = 20
			$Sprite2D.texture = load("res://Assets/Sprites/Objects/Items/CheeseStick.png")

func _process(_delta: float) -> void:
	if !noPlayer and who != "":
		if player != null:
			position = player.position
		else:
			queue_free()
		if PlayerStats.AllPlayerStats[who]["Stick"] == false:
			queue_free()

func _physics_process(delta: float) -> void:
	if noPlayer:
		if !is_on_floor():
			velocity.y += LevelMan.Gravity * delta
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not noPlayer:
		if body.has_method("takeDamage") and not body.name.begins_with("Boss") or body.name.begins_with("Boss") and LevelMan.BossFightOn:
			body.takeDamage(damage)
			PlayerStats.AllPlayerStats[who]["Stick"] = false
			queue_free()

func _on_pick_up_area_body_entered(body: Node2D) -> void:
	if !PlayerStats.AllPlayerStats[body.name]["Stick"] and who == "":
		AchievMan.AddAchievement("Stick")
		who = body.whoAmI
		player = body
		set_collision_mask_value(1, false)
		PlayerStats.AllPlayerStats[body.name]["Stick"] = true
		PlayerStats.AllPlayerStats[body.name]["StickType"] = stickType
		noPlayer = false
