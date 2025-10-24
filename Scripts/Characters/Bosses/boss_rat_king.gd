extends CharacterBody2D

var health: int = 160
signal RatStart()
signal RatStop()
var action := ""
var fall = true
@export var bossMusicPlayer: AudioStreamPlayer
@export var levelMusicPlayer: AudioStreamPlayer
@export var entryThing: Area2D


func _ready() -> void:
	$HealthBar/ProgressBar.max_value = health
	$HealthBar/ProgressBar.value = health
	$HealthBar/Label.text = str(health)


func startFight() -> void:
	$Timer.start(0.1)
	LevelMan.BossCamPos = Vector2(-2747.0, -324.0)
	LevelMan.CamZoom = Vector2(0.55, 0.55)
	RatStart.emit()

func _on_timer_timeout() -> void:
	if LevelMan.BossFightOn:
		chooseRandomAttack()
	else:
		bossMusicPlayer.stop()
		levelMusicPlayer.play()

func chooseRandomAttack() -> void:
	match randi_range(1,2):
		1: 
			action = "smash"
		2:
			bigCheese()
			$Timer.start(1.5)

func bigCheese() -> void:
	var cheeseInstance = preload("uid://2k45qt2g31y8").instantiate()
	cheeseInstance.bigCheese = true
	get_tree().current_scene.call_deferred("add_child", cheeseInstance)
	cheeseInstance.position = global_position + Vector2(0, -20)
	cheeseInstance.velocity = Vector2(0, -600)

func _physics_process(delta: float) -> void:
	if !is_on_floor() and fall:
		velocity.y += LevelMan.Gravity * delta
	
	if action == "smash" and is_on_floor():
		velocity.y += -1000
	if action == "smash" and !is_on_floor() and velocity.y >= 0.0:
		action = "smash2"
	
	if action == "smash2" and position.y <= -580:
		action = "spin"
		velocity.y = 0
		fall = false
	
	if action == "spin":
		global_rotation_degrees += 10
		if round(global_rotation_degrees) == -10:
			action = ""
			global_rotation = 0.0
			fall = true
			$Area2D.monitoring = true
			velocity.y = 1500
			$Timer.start(2.0)
	
	if is_on_floor():
		$Area2D.monitoring = false
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	body.hurt(15)
	if !PlayerStats.IsPlayerAlive(body.name):
		endBattle()

func _on_audio_stream_player_finished() -> void:
	endBattle()
	AchievMan.AddAchievement("TheRatKing")

func takeDamage(damage: int):
	health -= damage
	$HealthBar/ProgressBar.value = health
	$HealthBar/Label.text = str(health)
	if health <= 0:
		endBattle()
		AchievMan.AddAchievement("TheRatKing")
		queue_free()

func endBattle() -> void:
	LevelMan.BossFightOn = false
	RatStop.emit()
	LevelMan.CamZoom = Vector2(1, 1)
	bossMusicPlayer.stop()
	levelMusicPlayer.play()
	entryThing.fightEnded()
