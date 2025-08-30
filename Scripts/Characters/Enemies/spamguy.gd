extends CharacterBody2D

var speed = 100
var direction := 1
var wallCooldown := 0.0

func _ready() -> void:
	var rand = randi_range(0,3)
	AchievMan.AddAchievement("Trash")
	if rand == 0:
		$BDSpamguy.disabled = false
		$Sprite2D.texture = load("res://Assets/Sprites/Characters/Enemies/BadlyDrawnSpamton.png")
		speed = 4200
	if rand == 1:
		$Brunton1.disabled = false
		$Sprite2D.texture = load("res://Assets/Sprites/Characters/Enemies/Brunton1.png")
		speed = 7800
	if rand == 2:
		$Brunton2.disabled = false
		$Sprite2D.texture = load("res://Assets/Sprites/Characters/Enemies/Brunton2.png")
		speed = 7800
	if rand == 3:
		$Ksawton.disabled = false
		$Sprite2D.texture = load("res://Assets/Sprites/Characters/Enemies/Ksawton.png")
		speed = 6000

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += LevelMan.Gravity * delta
	velocity.x = speed * direction * delta
	if is_on_wall() and wallCooldown <= 0.0:
		wallCooldown = 0.2
		direction *= -1
	move_and_slide()
	if wallCooldown > 0.0:
		wallCooldown -= 0.1
