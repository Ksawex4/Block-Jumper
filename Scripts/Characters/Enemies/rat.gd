extends CharacterBody2D

enum Actions {
	NONE,
	RUN,
	CHEESE,
}
@export var King: CharacterBody2D
var Action := Actions.NONE
var Throw_delay := 0.0
var Speed := 500
var Direction: int = [-1,1].pick_random()
var Wall_stop := false
@onready var Start_pos = position 

func _ready() -> void:
	if King:
		King.connect("RatStart", Callable(self, "start"))
		King.connect("RatStop", Callable(self, "stop"))


func start() -> void:
	$Timer.start(0.3)
	Action = Actions.NONE


func stop() -> void:
	$Timer.stop()
	Action = Actions.NONE


func _on_timer_timeout() -> void:
	if LevelMan.Boss_fight:
		match randi_range(1,2):
			1:
				velocity = Vector2.ZERO
				Action = Actions.RUN
				$Timer.start(15.0)
				$Area2D/CollisionShape2D2.disabled = false
			2:
				Action = Actions.CHEESE
				$Timer.start(15.0)
				$Area2D/CollisionShape2D2.disabled = true
	else:
		Action = Actions.NONE


func _physics_process(delta: float) -> void:
	if Action != Actions.RUN:
		position = lerp(position, Start_pos, 3 * delta)
	if Throw_delay > 0.0:
		Throw_delay -= 0.1
	
	match Action:
		Actions.CHEESE:
			if Throw_delay <= 0.0:
				Throw_delay = randf_range(8.5, 15.5)
				throw_cheese(NovaFunc.get_nearest_player(global_position))
		Actions.RUN:
			if not is_on_floor():
				velocity.y += LevelMan.Gravity
			if is_on_wall() and not Wall_stop:
				Wall_stop = true
				Direction *= -1
			if not is_on_wall() and Wall_stop:
				Wall_stop = false
			if is_on_floor():
				velocity.x = Speed * Direction
			move_and_slide()


func throw_cheese(player: CharacterBody2D) -> void:
	var distanceVector = player.global_position - global_position + Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
	var cheeseVelocity = distanceVector.normalized() * 250
	var cheeseObject = preload("uid://2k45qt2g31y8").instantiate()
	get_tree().current_scene.add_child(cheeseObject)
	cheeseObject.velocity = cheeseVelocity
	cheeseObject.position = global_position


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(1)
	if not PlayerStats.is_player_alive(body.name):
		King.end_fight()
