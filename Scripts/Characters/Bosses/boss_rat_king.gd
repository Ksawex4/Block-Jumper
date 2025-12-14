extends CharacterBody2D

enum Actions {
	NONE,
	SMASH,
	SMASH2,
	SPIN,
}
var Health := 160
var Action: Actions = Actions.NONE
@export var Boss_music_player: AudioStreamPlayer
@export var Level_music_player: AudioStreamPlayer
@export var Entry_thing: Area2D
@export var Player_counter: Area2D
var Battle_player_name := ""
signal RatStart()
signal RatStop()


func _ready() -> void:
	$HealthBar/ProgressBar.max_value = Health
	$HealthBar/ProgressBar.value = Health
	$HealthBar/Label.text = str(Health)
	if GameMan.Killed_bosses["RatKing"]:
		queue_free()


func _physics_process(_delta: float) -> void:
	if LevelMan.Boss_fight:
		PlayerStats.Follow_who = Battle_player_name
	if not is_on_floor():
		velocity.y += LevelMan.Gravity
	
	match Action:
		Actions.NONE: pass
		Actions.SMASH:
			if is_on_floor():
				velocity.y = -1000
			if not is_on_floor() and velocity.y >= 0.0 and position.y <= -580:
				Action = Actions.SPIN
		Actions.SPIN:
			global_rotation_degrees += 10
			if round(global_rotation_degrees) == -10:
				Action = Actions.NONE
				global_rotation = 0.0
				$Area2D.monitoring = true
				velocity.y = 1500
				$Timer.start(2.0)
	
	if is_on_floor():
		$Area2D.monitoring = false
	move_and_slide()


func _on_timer_timeout() -> void:
	if LevelMan.Boss_fight:
		if PlayerStats.is_player_alive(Battle_player_name):
			pick_random_attack()
		else:
			end_fight()
	else:
		Boss_music_player.stop()
		Level_music_player.play()


func start_fight() -> void:
	if not GameMan.Killed_bosses["RatKing"] or not GameMan.Spared_bosses["RatKing"]:
		$Timer.start(0.1)
		LevelMan.Boss_cam_pos = Vector2(-2747.0, -324.0)
		LevelMan.Cam_zoom = Vector2(0.55, 0.55)
		RatStart.emit()
		Battle_player_name = NovaFunc.get_nearest_player(global_position).WhoAmI
		PlayerStats.Follow_who = Battle_player_name
		DebugMan.dprint("[boss_rat_king, start_fight] fight started")
	else:
		end_fight()
	
	#Engine.time_scale = 0.5
	#AudioServer.playback_speed_scale = 0.5
	#LevelMan.Gravity = 5


func pick_random_attack() -> void:
	match randi_range(1,2):
		1: 
			Action = Actions.SMASH
		2:
			big_cheese()
			$Timer.start(1.5)


func big_cheese() -> void:
	var cheeseInstance = preload("uid://2k45qt2g31y8").instantiate()
	cheeseInstance.Big_cheese = true
	get_tree().current_scene.call_deferred("add_child", cheeseInstance)
	cheeseInstance.position = global_position + Vector2(0, -20)
	cheeseInstance.velocity = Vector2(0, -600)


func take_damage(damage: int):
	if LevelMan.Boss_fight:
		Health -= damage
	$HealthBar/ProgressBar.value = Health
	$HealthBar/Label.text = str(Health)
	if Health <= 0:
		end_fight()
		AchievMan.add_achievement("TheRatKing")
		GameMan.Killed_bosses["RatKing"] = true
		queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	body.take_damage(15)
	if PlayerStats.Player_stats[body.WhoAmI].Health - 15 <= 0:
		end_fight()


func _on_audio_stream_player_finished() -> void:
	end_fight()
	AchievMan.add_achievement("TheRatKing")
	GameMan.Spared_bosses["RatKing"] = true


func end_fight() -> void:
	LevelMan.Boss_fight = false
	RatStop.emit()
	LevelMan.Cam_zoom = Vector2(1, 1)
	Boss_music_player.stop()
	Level_music_player.play()
	Entry_thing.fight_ended()
	DebugMan.dprint("[boss_rat_king.gd] Fight ended")
