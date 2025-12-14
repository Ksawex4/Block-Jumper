extends Area2D

@export var Door: Node2D
@export var Door_close_pos: Vector2 = Vector2.ZERO
@export var Door_open_pos: Vector2
@export var Boss_music_player: AudioStreamPlayer
@export var Level_music_player: AudioStreamPlayer
@export var Boss: CharacterBody2D
@export var Camera_settings := {"Pos": Vector2(0.0 ,0.0), "Zoom": Vector2(1.0, 1.0)}
@export var Player_counter: Area2D
@export var Open := false


func _ready() -> void:
	if Door and not Door_open_pos:
		Door_open_pos = Door.position
	if Door and not Door_close_pos:
		Door_close_pos = Door.position


func _on_body_entered(_body: Node2D) -> void:
	if Player_counter and Player_counter.get("Player_count") == 1 and Boss:
		LevelMan.Boss_cam_pos = Camera_settings["Pos"]
		LevelMan.Cam_zoom = Camera_settings["Zoom"]
		LevelMan.Boss_fight = true
		set_deferred("monitoring", false)
		Open = false
		await get_tree().create_timer(0.5).timeout
		if Level_music_player:
			Level_music_player.stop()
		if Boss_music_player:
			Boss_music_player.play()
		Boss.start_fight()


func _physics_process(delta: float) -> void:
	if Open and Door:
		Door.position = lerp(Door.position, Door_open_pos, 12 * delta)
	elif not Open and Door:
		Door.position = lerp(Door.position, Door_close_pos, 12 * delta)


func fight_ended() -> void:
	Open = true
