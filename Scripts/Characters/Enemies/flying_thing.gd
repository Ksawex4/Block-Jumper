extends CharacterBody2D

const movementSpeed = 50
var goal: Node
@export var goTo00AtStart = true
 
func _ready() -> void:
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(1).timeout
	var players = get_tree().get_nodes_in_group("players")
	if players:
		goal = players.pick_random()
	if goal:
		$NavigationAgent2D.target_position = goal.global_position
	if goTo00AtStart:
		position = Vector2(0.0, 0.0)
	$CollisionShape2D.disabled = false
	$Timer.start(0.2)

func _physics_process(_delta: float) -> void:
	if !$NavigationAgent2D.is_target_reached():
		var navPointDirection = to_local($NavigationAgent2D.get_next_path_position()).normalized()
		velocity = navPointDirection * movementSpeed
		$Sprite2D.rotation = velocity.angle()
		move_and_slide()

func _on_timer_timeout() -> void:
	if goal:
		if $NavigationAgent2D.target_position != goal.global_position:
			$NavigationAgent2D.target_position = goal.global_position
	else:
		var players = get_tree().get_nodes_in_group("players")
		if players:
			goal = players.pick_random()
	$Timer.start(0.2)
