extends CharacterBody2D

var xSpeed: float # This is stored inside PlayerStats.gd
var jumpHeight: float # This too
@export var whoAmI := "Fency"
@export var gravityDifference := 0.0
var stickInstance
var stickSpawnCooldown := 0
var controls

func _ready() -> void:
	xSpeed = PlayerStats.AllPlayerStats[whoAmI]["xSpeed"]
	jumpHeight = PlayerStats.AllPlayerStats[whoAmI]["JumpHeight"]
	controls = InputMan.GetControls(whoAmI)
	SignalMan.emit_signal("SceneChanged")
	if controls == null:
		push_error(whoAmI, ": Controls == null!")
		get_tree().quit(-1)
	SignalMan.connect("UpdateBars", Callable(self, "_update_bar"))
	SignalMan.connect("UpdateControls", Callable(self, "_update_controls"))
	_update_bar()
	checkIfDuck()
	$AnimatedSprite2D.play("default")
#func _ready():
	#print("xSpeed: {speed}".format({"speed": xSpeed})) this is how to fuck a string, 2025-07-20 14:40

func _spawn_bouncy():
	var bouncy = load("res://Scenes/Characters/NPCs/bouncy_onurb.tscn")
	var instance = bouncy.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = position

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_B) and !Input.is_key_pressed(KEY_CTRL) and PlayerStats.DebugMode:
		_spawn_bouncy()
	
	if Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_B) and PlayerStats.DebugMode:
		for child in get_tree().current_scene.get_children():
			if child.scene_file_path.get_file().get_basename() == "bouncy_onurb":
				child.queue_free()
	
	if !is_on_floor():
		velocity.y += (LevelMan.Gravity + gravityDifference) * delta
	
	var xAxis = 0
	var axis = Vector2(0, 0)
	if LevelMan.Os != "Android":
		xAxis = InputMan.GetKeyAxis(controls["left"], controls["right"])
	elif whoAmI == PlayerStats.FollowWho:
		axis = getJoystickAxis()
		xAxis = axis.x
	
	if !BobMan.CanBobsAddVelocity:
		velocity.x = xSpeed * delta * xAxis
	else:
		velocity.x += (xSpeed/8) * delta * xAxis
	
	if is_on_floor() and Input.is_key_pressed(controls["up"]) or is_on_floor() and axis.y < 0:
		velocity.y = jumpHeight
	
	if whoAmI == "PanLoduwka" and !PlayerStats.IsPlayerDuck("PanLoduwka"):
		if velocity.x > 0:
			$AnimatedSprite2D.play("right")
		elif velocity.x < 0:
			$AnimatedSprite2D.play("left")
		else:
			$AnimatedSprite2D.play("default")
	
	if PlayerStats.AllPlayerStats[whoAmI]["Stick"] and stickSpawnCooldown <= 0 and stickInstance == null:
		_spawn_stick()
	if stickSpawnCooldown > 0:
		stickSpawnCooldown -= 1
	
	checkIfDuck()
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_meta("instanceID"):
		var instanceId = body.get_meta("instanceID")
		LevelMan.PersistenceKeys.append(instanceId)
	if body.has_meta("damage"):
		var damage = body.get_meta("damage")
		var sucess = PlayerStats.Hurt(whoAmI, damage)
		if sucess == null:
			push_error("Failed to hurt player", whoAmI, damage)
	if body.has_meta("beans"):
		PlayerStats.AddBeans(body.get_meta("beans"))
	if body.scene_file_path.get_file() == "flying_thing.tscn":
		LevelMan.FlyingThingAlive = false
		print("salt will not appear in next level")
	body.queue_free()

func _spawn_stick():
	stickSpawnCooldown = 3
	var scene = get_tree().current_scene
	if stickInstance:
		stickInstance.queue_free()
	stickInstance = preload("res://Scenes/Objects/Items/stick.tscn").instantiate()
	scene.add_child.call_deferred(stickInstance)
	stickInstance.who = whoAmI

func _update_bar():
	var Stats = PlayerStats.GetPlayerStats(whoAmI)
	$HPBar/Label.text = "%s/%s" % [int(Stats["HP"]), int(Stats["MaxHP"])]
	if !PlayerStats.IsPlayerAlive(whoAmI):
		queue_free()

func _update_controls():
	controls = InputMan.GetControls(whoAmI)

func checkIfDuck():
	if PlayerStats.IsPlayerDuck(whoAmI):
		match whoAmI:
			"Fency": 
				$AnimatedSprite2D.play("CurseOfADuck")
				$AnimatedSprite2D.scale = Vector2(0.167, 0.212)
			"PanLoduwka":
				$AnimatedSprite2D.play("CurseOfADuck")
				$AnimatedSprite2D.scale = Vector2(0.141, 0.278)
			"Toasty":
				$AnimatedSprite2D.play("CurseOfADuck")
				$AnimatedSprite2D.scale = Vector2(0.167, 0.192)

func getJoystickAxis():
	var axis = Vector2(0,0)
	if PlayerStats.JoystickPosVector.x > 0.2: # right
		axis.x = 1
	elif PlayerStats.JoystickPosVector.x < -0.2: # left
		axis.x = -1
	if PlayerStats.JoystickPosVector.y < -0.5: # jump
		axis.y = -1
	return(axis)
