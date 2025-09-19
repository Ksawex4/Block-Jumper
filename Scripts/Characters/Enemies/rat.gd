extends CharacterBody2D

@export var King: Node2D
@export var floorRunHeight: float = 0.0
var cheese := preload("uid://2k45qt2g31y8")
var action: String = ""
var throwDelay: float = 0.0
var speed: float = 30000.0
var direction: int = [-1,1].pick_random()
var wallCooldown: float = 0.0
@onready var startPos = position

func _ready() -> void:
	if King:
		King.connect("RatThrowCheese", Callable(self, "cheeseThrow"))
		#King.connect("RatRun", Callable(self, "run"))

#func run() -> void:
	#action = "run"
	#$Timer.start(15.0)
#
func cheeseThrow() -> void:
	#action = "throw"
	#$Timer.start(15.0)
	$Timer.start(0.3)

func _on_timer_timeout() -> void:
	#action = ""
	if LevelMan.BossFightOn:
		match randi_range(1,2):
			1:
				action = "run"
				$Timer.start(15.0)
			2:
				action = "throw"
				$Timer.start(15.0)
	else:
		action = ""

func _physics_process(delta: float) -> void:
	if action != "run":
		position = lerp(position, startPos, 0.05)
		velocity = Vector2.ZERO
	if throwDelay > 0.0:
		throwDelay -= 0.1
	match action:
		"throw":
			var players = get_tree().get_nodes_in_group("players")
			var nearestDistance: float = -1
			var nearestPlayer: Node2D
			if throwDelay <= 0.0 and players:
				throwDelay = randf_range(5.5, 8.8)
				for player in players:
					var d: float = player.position.distance_squared_to(position)
					if d < nearestDistance or nearestDistance == -1:
						nearestDistance = d
						nearestPlayer = player
			if nearestPlayer:
				throwCheeseAt(nearestPlayer)
		"run":
			if wallCooldown > 0.0:
				wallCooldown -= 0.1
			if !is_on_floor():
				velocity.y += LevelMan.Gravity * delta
			if is_on_wall() and wallCooldown <= 0.0:
				wallCooldown = 1.0
				direction *= -1
			if is_on_floor():
				velocity.x = speed * delta * direction
			move_and_slide()

func throwCheeseAt(player: Node2D) -> void:
	var distanceVector = player.global_position - global_position + Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
	var cheeseVelocity = distanceVector.normalized() * 250
	var cheeseObject = cheese.instantiate()
	get_tree().current_scene.add_child(cheeseObject)
	cheeseObject.velocity = cheeseVelocity
	cheeseObject.position = global_position

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.hurt(1)
	if !PlayerStats.IsPlayerAlive(body.name):
		LevelMan.BossFightOn = false
