extends CharacterBody2D

var bigCheese: bool = false

func _ready() -> void:
	if bigCheese:
		scale = Vector2(3,3)
		$BigCheese.play()

func _physics_process(delta: float) -> void:
	if bigCheese:
		if !is_on_floor():
			velocity.y += LevelMan.Gravity * delta
	move_and_slide()

func _on_free_box_body_entered(_body: Node2D) -> void:
	if bigCheese:
		for numbers in [Vector2(100, -20), Vector2(100, -80), Vector2(-100, -80), Vector2(-100, -20)]:
			var distanceVector = (global_position + numbers ) - global_position + Vector2(randf_range(-50.0, 50.0), randf_range(-50.0, 50.0))
			var cheeseVelocity = distanceVector.normalized() * 250
			var cheestance = preload("uid://2k45qt2g31y8").instantiate()
			get_tree().current_scene.call_deferred("add_child", cheestance)
			cheestance.position = global_position
			cheestance.velocity = cheeseVelocity
		queue_free()
	else:
		if randi_range(1, 40) == 14:
			var cheestancetick = preload("uid://b335udwa3qnb").instantiate()
			cheestancetick.noPlayer = true
			cheestancetick.stickType = "Cheese"
			get_tree().current_scene.call_deferred("add_child", cheestancetick)
			cheestancetick.position = global_position
		queue_free()

func _on_attack_box_body_entered(body: Node2D) -> void:
	$AttackBox.set_deferred("monitoring", false)
	$Sprite2D.visible = false
	if bigCheese:
		body.hurt(5)
		$AudioStreamPlayer.volume_db = -80.0
		$BigCheese.play()
	else:
		body.hurt(1)
	if !PlayerStats.IsPlayerAlive(body.name):
		LevelMan.BossFightOn = false
	velocity = Vector2.ZERO
	$AudioStreamPlayer.play()

func _on_audio_stream_player_finished() -> void:
	queue_free()
