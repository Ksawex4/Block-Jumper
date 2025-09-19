extends CharacterBody2D

var health: int = 100
signal RatThrowCheese()
signal RatRun()
var action := ""
var cheeseObject := preload("uid://2k45qt2g31y8")

func _on_timer_timeout() -> void:
	action = "smash"

func chooseRandomAttack() -> void:
	match randi_range(1,4):
		1:
			RatThrowCheese.emit()
			$Timer.start(15.0)
		2:
			RatRun.emit()
			$Timer.start(15.0)
		3: 
			action = "smash"
			$Timer.start(10.0)
		4:
			bigCheese()
			$Timer.start(5.0)

func bigCheese() -> void:
	var cheeseInstance = cheeseObject.instantiate()
	cheeseInstance.bigCheese = true
	get_tree().current_scene.call_deferred("add_child", cheeseInstance)
	cheeseInstance.position = global_position + Vector2(0, -20)
	cheeseInstance.velocity = Vector2(0, -600)

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += LevelMan.Gravity * delta
	
	if action == "smash" and is_on_floor():
		velocity.y += -1000
	if action == "smash" and !is_on_floor() and velocity.y >= 0.0:
		action = ""
		velocity.y += 1500
		$Area2D.monitoring = true
	if is_on_floor():
		$Area2D.monitoring = false
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.hurt(25)
