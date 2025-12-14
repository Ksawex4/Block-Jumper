extends CharacterBody2D

@export var Damage: int = 20
@export var canMove: bool = false
@export var canJump: bool = false
var Speed := randf_range(100.0 , 150.0)
var Jump_height := randf_range(-300, -450)
var Direction: int = [-1, 1].pick_random()
var Wall_stop: bool = false

func _ready() -> void:
	if Damage < 120:
		Damage = randi_range(Damage-1,Damage+7)
		$AnimatedSprite2D.play("default")
	else:
		$AnimatedSprite2D.play("deadly")

func _physics_process(_delta: float) -> void:
	if (canJump or canMove) and not is_on_floor():
		velocity.y += LevelMan.Gravity
	
	if canJump and is_on_floor() and randi_range(1,25) == 6:
		velocity.y = Jump_height
	
	if not Wall_stop and is_on_wall():
		Wall_stop = true
		Direction *= -1
	if Wall_stop and not is_on_wall():
		Wall_stop = false
	
	if canMove:
		velocity.x = Speed * Direction
	
	move_and_slide()


func take_damage(_damage: int) -> void:
	AchievMan.add_achievement("BlockKiller")
	queue_free()
