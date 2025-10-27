extends CharacterBody2D

var xSpeed: float # This is stored inside PlayerStats.gd
var jumpHeight: float # This too
@export var whoAmI: String = "Fency"
@export var gravityDifference: float = 0.0
var stickInstance: Node2D
var stickSpawnCooldown: int = 0
@export var controls: Dictionary = {"Left": "FencyLeft", "Right": "FencyRight", "Jump": "FencyJump"}

func _ready() -> void:
	if !PlayerStats.IsPlayerAlive(whoAmI):
		queue_free()
		print("[player.gd, ", self.name, "] Im dead")
	xSpeed = PlayerStats.AllPlayerStats[whoAmI]["xSpeed"]
	jumpHeight = PlayerStats.AllPlayerStats[whoAmI]["JumpHeight"]
	SignalMan.emit_signal("SceneChanged")
	SignalMan.connect("UpdateBars", Callable(self, "_update_bar"))
	_update_bar()
	checkIfDuck()
	$AnimatedSprite2D.play("default")
	_spawn_stick()
#func _ready():
	#print("xSpeed: {speed}".format({"speed": xSpeed})) this is how to fuck a string, 2025-07-20 14:40

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("SpawnBouncy_onurB") and PlayerStats.DebugMode:
		_spawn_bouncy()
	if Input.is_action_pressed("DeleteAllBouncy_onurBs") and PlayerStats.DebugMode:
		for child in get_tree().current_scene.get_children():
			if child.scene_file_path.get_file().get_basename() == "bouncy_onurb":
				child.queue_free()
	
	if !is_on_floor():
		if LevelMan.Gravity > 0:
			velocity.y += (LevelMan.Gravity + gravityDifference) * delta
		elif LevelMan.Gravity < 0:
			velocity.y += (LevelMan.Gravity + gravityDifference) * delta
	
	var axis: Vector2 = Vector2.ZERO
	axis = getJoystickAxis()
	if !BobMan.CanBobsAddVelocity:
		velocity.x = xSpeed * delta * axis.x
	else:
		velocity.x += (xSpeed/8) * delta * axis.x
	if is_on_floor() and axis.y < 0:
		velocity.y = jumpHeight
	if not is_on_floor() and axis.y >= 0 and velocity.y < 0.0:
		velocity.y = 80
	
	if whoAmI == "PanLoduwka" and !PlayerStats.IsPlayerDuck("PanLoduwka"):
		if velocity.x > 0:
			$AnimatedSprite2D.play("right")
		elif velocity.x < 0:
			$AnimatedSprite2D.play("left")
		else:
			$AnimatedSprite2D.play("default")
	
	checkIfDuck()
	move_and_slide()

func _spawn_bouncy() -> void:
	var instance: Node2D = preload("uid://b83uowllfiji").instantiate()
	get_tree().current_scene.add_child(instance)
	instance.position = position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_meta("instanceID"):
		var instanceId: String = body.get_meta("instanceID")
		LevelMan.PersistenceKeys.append(instanceId)
	
	if body.has_meta("damage"):
		var damage: int = body.get_meta("damage")
		var sucess: bool = PlayerStats.Hurt(whoAmI, damage)
		if sucess == false:
			push_error("[player.gd, ", self.name ,"] Failed to get hurt, damage, whoAmI: ", damage, whoAmI)
		else:
			print("[player.gd, ", self.name, "] I lost ", damage, "HP")
	
	if body.has_meta("beans"):
		PlayerStats.AddBeans(body.get_meta("beans"))
		print("[player.gd, ", self.name, "] Collected ", body.get_meta("beans"), " Beans")
	
	if body.scene_file_path.get_file() == "flying_thing.tscn":
		LevelMan.FlyingThingAlive = false
		print("[player.gd, ", self.name, "] Salt will not appear in next level")
	
	if !body.scene_file_path.get_file().get_basename().begins_with("boss"):
		body.queue_free()


func _spawn_stick() -> void:
	var scene: Node2D = get_tree().current_scene
	if stickInstance:
		stickInstance.queue_free()
	stickInstance = preload("uid://b335udwa3qnb").instantiate()
	scene.add_child.call_deferred(stickInstance)
	stickInstance.who = whoAmI
	print("[player.gd, ", self.name, "] Spawned my stick")

func _update_bar() -> void:
	var Stats: Dictionary = PlayerStats.GetPlayerStats(whoAmI)
	$HPBar/Label.text = "%s/%s" % [int(Stats["HP"]), int(Stats["MaxHP"])]
	$HPBar/ProgressBar.value = int(Stats["HP"])
	$HPBar/ProgressBar.max_value = int(Stats["MaxHP"])
	if !PlayerStats.IsPlayerAlive(whoAmI):
		print("[player.gd, ", self.name, "] I died")
		queue_free()

func checkIfDuck() -> void:
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

func getJoystickAxis() -> Vector2:
	var axis: Vector2 = Vector2(0,0)
	if LevelMan.Os == "Android" and PlayerStats.FollowWho == whoAmI:
		var controller_axis := Input.get_axis("ControllerLeft", "ControllerRight")
		if PlayerStats.JoystickPosVector.x > 0.2 or controller_axis == 1: # right
			axis.x = 1
		elif PlayerStats.JoystickPosVector.x < -0.2 or controller_axis == -1: # left
			axis.x = -1
		if PlayerStats.MobileJump == 1 or Input.is_action_just_pressed("ControllerJump"): # jump
			axis.y = -1
	elif Input.get_connected_joypads().size() != 0 and PlayerStats.FollowWho == whoAmI:
		axis.x = Input.get_axis("ControllerLeft", "ControllerRight")
		if Input.is_action_pressed("ControllerJump"):
			axis.y = -1
	else:
		axis.x = Input.get_axis(controls["Left"], controls["Right"])
		if Input.is_action_pressed(controls["Jump"]):
			axis.y = -1
	return(axis)

func hurt(damage: int) -> void:
	PlayerStats.Hurt(whoAmI, damage)
