extends CharacterBody2D

var Stats: Player
@export var WhoAmI: String
var Has_left_n_right_anim := false
var Stick_instance: CharacterBody2D


func _ready() -> void:
	if WhoAmI:
		Stats = PlayerStats.Player_stats[WhoAmI]
		Stats.connect("Died", Callable(self, "_on_death"))
		Stats.connect("StatsChanged", Callable(self, "_update_bar"))
		_spawn_stick()
		check_duck_status()
		Stats.hurt(0)
		$AnimatedSprite2D.play("default")
		if $AnimatedSprite2D.sprite_frames.has_animation("left") and $AnimatedSprite2D.sprite_frames.has_animation("right"):
			Has_left_n_right_anim = true


func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		if LevelMan.Gravity > 0:
			velocity.y += (LevelMan.Gravity + Stats.Gravity_difference)
		elif LevelMan.Gravity < 0:
			velocity.y += (LevelMan.Gravity + Stats.Gravity_difference)
	
	var axis :=  Vector2(Input.get_axis(Stats.Controls["Left"], Stats.Controls["Right"]), -1 if Input.is_action_pressed(Stats.Controls["Jump"]) else 0)
	if axis.x == 0 and PlayerStats.Follow_who == WhoAmI:
		axis.x = Input.get_axis("ControllerLeft", "ControllerRight")
	
	if axis.y == 0 and PlayerStats.Follow_who == WhoAmI:
		if GameMan.is_mobile():
			axis.y = -1 if InputMan.Mobile_jump else 0
		else:
			axis.y = int(Input.is_action_just_pressed("ControllerJump"))
	
	
	if not BobMan.Can_add_velocity:
		velocity.x = Stats.X_speed * axis.x
	else:
		velocity.x += (Stats.X_speed/8) * axis.x
	if is_on_floor() and axis.y < 0:
		velocity.y = Stats.Jump_height
	if not is_on_floor() and axis.y >= 0 and velocity.y < 0.0:
		velocity.y = 80
	
	if Has_left_n_right_anim and $AnimatedSprite2D.animation != "CurseOfADuck":
		if velocity.x > 0.0:
			$AnimatedSprite2D.play("right")
		elif velocity.x < 0.0:
			$AnimatedSprite2D.play("left")
		else:
			$AnimatedSprite2D.play("default")
	
	move_and_slide()
	
	
	# Debug Mode Stuff
	if DebugMan.Debug_mode:
		if Input.is_action_pressed("SpawnBouncy_onurB") and not Input.is_action_pressed("DeleteAllBouncy_onurBs"):
			var instance: Node2D = preload("uid://b83uowllfiji").instantiate()
			get_tree().current_scene.add_child(instance)
			instance.position = global_position
		if Input.is_action_just_pressed("DeleteAllBouncy_onurBs"):
			for child in get_tree().current_scene.get_children():
				if child.scene_file_path.get_file().get_basename() == "bouncy_onurb":
					child.queue_free()


func take_damage(damage: int) -> void:
	Stats.hurt(damage)


func _spawn_stick() -> void:
	if not Stick_instance and Stats.has_stick():
		var scene := get_tree().current_scene
		Stick_instance = load("uid://b335udwa3qnb").instantiate()
		scene.add_child.call_deferred(Stick_instance)
		Stick_instance.Who = WhoAmI


func _update_bar() -> void:
	$HPBar/Label.text = "%s/%s" % [Stats.Health, Stats.Max_health]
	$HPBar/ProgressBar.value = Stats.Health
	$HPBar/ProgressBar.max_value = Stats.Max_health


func check_duck_status() -> void:
	if PlayerStats.is_player_duck(WhoAmI):
		match WhoAmI:
			"Fency": 
				$AnimatedSprite2D.play("CurseOfADuck")
				$AnimatedSprite2D.scale = Vector2(0.167, 0.212)
			"PanLoduwka":
				$AnimatedSprite2D.play("CurseOfADuck")
				$AnimatedSprite2D.scale = Vector2(0.141, 0.278)
			"Toasty":
				$AnimatedSprite2D.play("CurseOfADuck")
				$AnimatedSprite2D.scale = Vector2(0.167, 0.192)


func _on_death() -> void:
	if not PlayerStats.is_any_player_alive():
		LevelMan.change_level("title_screen.tscn")
	else:
		queue_free()
		DebugMan.dprint("[" + name + ", _on_death] Died, ", Stats.Health)


func _on_area_2d_body_entered(body: Node2D) -> void:
	var damage = body.get("Damage")
	if damage:
		take_damage(int(damage))
	
	if body.scene_file_path.get_file() == "flying_thing.tscn":
		LevelMan.Spawn_flying_thing = false
	
	if not body.scene_file_path.get_file().get_basename().begins_with("boss"):
		body.queue_free()
