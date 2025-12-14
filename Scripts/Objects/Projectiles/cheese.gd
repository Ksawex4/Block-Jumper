extends CharacterBody2D

var Big_cheese := false


func _ready() -> void:
	if Big_cheese:
		scale = Vector2(3,3)
		$BigCheese.play()


func _physics_process(_delta: float) -> void:
	if Big_cheese:
		if not is_on_floor():
			velocity.y += LevelMan.Gravity
	move_and_slide()


func _on_audio_stream_player_finished() -> void:
	queue_free()


func _on_free_box_body_entered(_body: Node2D) -> void:
	if Big_cheese:
		spawn_cheese4()
		queue_free()
	else:
		spawn_stick()
		queue_free()


func _on_attack_box_body_entered(body: Node2D) -> void:
	$AttackBox.set_deferred("monitoring", false)
	$Sprite2D.visible = false
	if Big_cheese:
		body.take_damage(5)
		$AudioStreamPlayer.volume_db = -80.0
		$BigCheese.play()
	else:
		body.take_damage(1)
	velocity = Vector2.ZERO
	$AudioStreamPlayer.play()


func spawn_cheese4() -> void:
	for numbers in [Vector2(100, -20), Vector2(100, -80), Vector2(-100, -80), Vector2(-100, -20)]:
		var distanceVector = (global_position + numbers ) - global_position + Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
		var cheeseVelocity = distanceVector.normalized() * 200
		var cheestance = preload("uid://2k45qt2g31y8").instantiate()
		get_tree().current_scene.call_deferred("add_child", cheestance)
		cheestance.position = global_position
		cheestance.velocity = cheeseVelocity


func spawn_stick() -> void:
	if randi_range(1, 40) == 14:
		var cheestick = preload("uid://b335udwa3qnb").instantiate()
		cheestick.No_player = true
		cheestick.Stick_type = Player.StickType.CHEESE
		get_tree().current_scene.call_deferred("add_child", cheestick)
		cheestick.position = global_position
