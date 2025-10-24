extends CharacterBody2D

var movementSpeed: int = 5
var goal: Node
var rotating: bool = false
var moving: bool = true
var slideeee: bool = false
@export var goTo00AtStart: bool = true
 
func _ready() -> void:
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(1).timeout
	var players: Array = get_tree().get_nodes_in_group("players")
	if players:
		goal = players.pick_random()
	if goal:
		$NavigationAgent2D.target_position = goal.global_position
	if goTo00AtStart:
		position = Vector2(0.0, 0.0)
	$CollisionShape2D.disabled = false
	$Timer.start(0.2)
	print("[flying_thing.gd] Spawned, goal: ", goal.name)
	match randi_range(1,2):
		1:
			movementSpeed = 50
			slideeee = false
		2: 
			movementSpeed = 1
			slideeee = true
	
	match randi_range(1,2):
		1: 
			$Sprite2D.scale = Vector2(0.044, 0.055)
			$Sprite2D.texture = preload("uid://cacwgynrspxgf")
		2: 
			$Sprite2D.scale = Vector2(0.07, 0.074)
			$Sprite2D.texture = preload("uid://bearliq6xur6b")

func _physics_process(_delta: float) -> void:
	moving = not rotating
	$NavigationAgent2D.debug_enabled = false if not PlayerStats.DebugMode else false
	if randi_range(1,100) == 58:
		rotating = true
	
	if rotating:
		global_rotation_degrees += 10
		if round(global_rotation_degrees) == -10:
			global_rotation = 0.0
			rotating = false
	
	if !$NavigationAgent2D.is_target_reached():
		var navPointDirection: Vector2 = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		if slideeee:
			velocity += navPointDirection * movementSpeed
		else:
			velocity = navPointDirection * movementSpeed
		$Sprite2D.rotation = velocity.angle()
		move_and_slide()

func _on_timer_timeout() -> void:
	if goal:
		if $NavigationAgent2D.target_position != goal.global_position:
			$NavigationAgent2D.target_position = goal.global_position
	else:
		var players: Array = get_tree().get_nodes_in_group("players")
		if players:
			goal = players.pick_random()
	$Timer.start(0.2)

func takeDamage(_damage: int) -> void:
	AchievMan.AddAchievement("Saltiest")
	queue_free()
