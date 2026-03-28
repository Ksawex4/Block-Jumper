extends CharacterBody2D

@export var speed: float = 250.0
@export var info_label: Label
var players_in_body: Array[Node]
var player_riding: CharacterBody2D = null
var spinlocity: float = 0.0


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += LevelMan.Gravity
	
	if players_in_body.size() > 0 and player_riding == null and Input.is_action_just_pressed("Interact"):
		player_riding = NovaFunc.get_node_from_group(PlayerStats.Follow_who) if players_in_body.has(NovaFunc.get_node_from_group(PlayerStats.Follow_who)) else players_in_body[0]
	elif player_riding != null and Input.is_action_just_pressed("Interact"):
		player_riding.rotation_degrees = 0
		player_riding = null
	
	if player_riding != null:
		player_riding.velocity = velocity
		
		var player_offset: Vector2 = Vector2(cos(rotation - 3.14/2), sin(rotation - 3.14/2)) * 20
		player_riding.global_position = global_position + player_offset
		player_riding.rotation_degrees = rotation_degrees
		
		var axis: Vector2
		axis.x = Input.get_axis(player_riding.Stats.Controls["Left"], player_riding.Stats.Controls["Right"])
		if axis.x == 0 and PlayerStats.Follow_who == player_riding.WhoAmI:
			axis.x = Input.get_axis("ControllerLeft", "ControllerRight")
		
		velocity.x = speed * axis.x
		
		if velocity.x > 0.0:
			spinlocity += 0.5
		elif velocity.x < 0.0:
			spinlocity -= 0.5
		else:
			spinlocity = spinlocity - 0.1 if spinlocity > 0.1 else spinlocity + 0.1 if spinlocity < -0.1 else 0.0
		
		spinlocity = clampf(spinlocity, -7.0, 7.0)
	
	rotate(deg_to_rad(spinlocity * 60 * delta))
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !players_in_body.has(body):
		players_in_body.append(body)
	
	if players_in_body.size() > 0:
		info_label.show()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if players_in_body.has(body):
		players_in_body.erase(body)
	
	if players_in_body.size() == 0:
		info_label.hide()
