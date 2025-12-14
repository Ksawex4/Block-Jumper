extends CharacterBody2D


@export var Who: String = ""
@export var No_player := false
var Stick_type := Player.StickType.NORMAL
var Playah: CharacterBody2D
var Damage := 40


func _ready() -> void:
	if No_player:
		set_collision_mask_value(1, true)
	elif not No_player and Who != "":
		Playah = NovaFunc.get_node_from_group(Who)
		Stick_type = PlayerStats.Player_stats[Who].Stick
	
	match Stick_type:
		Player.StickType.NONE:
			queue_free()
		Player.StickType.NORMAL:
			Damage = 40
			$Sprite2D.texture = preload("uid://bgjxr6kgptfv4")
		Player.StickType.CHEESE:
			Damage = 20
			$Sprite2D.texture = preload("uid://bln2uwbsqudqs")

func _process(_delta: float) -> void:
	if not No_player and Who != "":
			if Playah != null:
				position = Playah.position
			else:
				queue_free()
			if not PlayerStats.has_stick(Who):
				queue_free()


func _physics_process(_delta: float) -> void:
	if No_player:
		if not is_on_floor():
			velocity.y += LevelMan.Gravity
		move_and_slide()


func _on_attack_area_body_entered(body: Node2D) -> void:
	if not No_player and Who != "":
		if (
			body.has_method("take_damage") and 
			(not body.name.begins_with("Boss") or (body.name.begins_with("Boss") and LevelMan.Boss_fight))
		):
			body.take_damage(Damage)
			PlayerStats.used_stick(Who)


func _on_pick_up_area_body_entered(body) -> void:
	if not PlayerStats.has_stick(body.WhoAmI) and Who == "":
		AchievMan.add_achievement("Stick")
		set_collision_mask_value(1, false)
		body.Stick_instance = self
		Who = body.WhoAmI
		Playah = body
		PlayerStats.add_stick(body.WhoAmI, Stick_type)
		No_player = false
