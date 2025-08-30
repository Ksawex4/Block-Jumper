extends CharacterBody2D

var Speed = 5400
var direction = [1, -1].pick_random()
var wallCooldown = 0.0

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += LevelMan.Gravity * delta
	if is_on_floor():
		velocity.y = -randi_range(40, 450)
	velocity.x = Speed * direction * delta
	if is_on_wall() and wallCooldown <= 0.0:
		wallCooldown = 0.2
		direction *= -1
	if wallCooldown > 0.0:
		wallCooldown -= 0.1
	move_and_slide()
