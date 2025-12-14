extends CharacterBody2D

var Speed := 5400
var Direction: int = [1,-1].pick_random()
var Wall_stop := false


func _physics_process(_delta: float) -> void:
	#Velocity.y
	if is_on_floor():
		velocity.y = -randi_range(40,450)
	else:
		velocity.y += LevelMan.Gravity
	
	#Velocity.x
	if Wall_stop and not is_on_wall():
		Wall_stop = false
	if not Wall_stop and is_on_wall():
		Wall_stop = true
		Direction *= -1
	velocity.x = Speed * Direction
	
	move_and_slide()
	
	
