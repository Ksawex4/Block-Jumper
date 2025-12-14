extends CharacterBody2D

@export var Can_move: bool = false
@export var Can_jump: bool = false
@export var Beans: int = 1
var Speed: float = randf_range(100.0 , 150.0)
var Jump_height: float = randf_range(-300.0, -450.0)
var Direction: int = [-1, 1].pick_random()
var Wall_stop := false

func _ready() -> void:
	$AnimatedSprite2D.play()


func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += LevelMan.Gravity
	if Can_jump and is_on_floor() and randi_range(1, 25) == 6:
		velocity.y = Jump_height
	
	if not Wall_stop and is_on_wall():
		Wall_stop = true
		Direction *= -1
	
	if Can_move:
		velocity.x = Speed * Direction
	
	if Wall_stop and not is_on_wall():
		Wall_stop = false
	
	move_and_slide()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	PlayerStats.add_beans(Beans)
	queue_free()
