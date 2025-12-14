extends CharacterBody2D

var Movement_speed: int = 3
var Goal: Node
var Rotating: bool = false
var Moving: bool = true
var Slideeee: bool = false
var Damage := 99
@export var Go_to_00_at_start: bool = true

func _ready() -> void:
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.1).timeout
	var players: Array = get_tree().get_nodes_in_group("players")
	if players:
		Goal = players.pick_random()
	if Goal:
		$NavigationAgent2D.target_position = Goal.global_position
	if Go_to_00_at_start:
		position = Vector2(0.0, 0.0)
	$CollisionShape2D.disabled = false
	$Timer.start(0.2)
	print("[flying_thing.gd, _ready] Goal: ", Goal.name)
	match randi_range(1,2):
		1:
			Movement_speed = 50
			Slideeee = false
		2: 
			Movement_speed = 3
			Slideeee = true
	
	match randi_range(1,2):
		1: 
			$Sprite2D.scale = Vector2(0.044, 0.055)
			$Sprite2D.texture = preload("uid://cacwgynrspxgf")
		2: 
			$Sprite2D.scale = Vector2(0.07, 0.074)
			$Sprite2D.texture = preload("uid://bearliq6xur6b")


func _physics_process(_delta: float) -> void:
	Moving = not Rotating
	$NavigationAgent2D.debug_enabled = false if not DebugMan.Debug_mode else false
	if randi_range(1,100) == 58:
		Rotating = true
	
	if Rotating:
		global_rotation_degrees += 10
		if round(global_rotation_degrees) == -10:
			global_rotation = 0.0
			Rotating = false
	
	if not $NavigationAgent2D.is_target_reached():
		var navPointDirection: Vector2 = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		if Slideeee:
			velocity += navPointDirection * Movement_speed
		else:
			velocity = navPointDirection * Movement_speed
		$Sprite2D.rotation = velocity.angle()
		move_and_slide()


func _on_timer_timeout() -> void:
	if Goal:
		if $NavigationAgent2D.target_position != Goal.global_position:
			$NavigationAgent2D.target_position = Goal.global_position
	else:
		var players: Array = get_tree().get_nodes_in_group("players")
		if players:
			Goal = players.pick_random()
	$Timer.start(0.2)


func take_damage(_damage: int) -> void:
	AchievMan.add_achievement("Saltiest")
	queue_free()
