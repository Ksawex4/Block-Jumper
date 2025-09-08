extends CharacterBody2D

var isColliding: bool = false
var save: bool = false
@export var alwaysFailToSave: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(_delta: float) -> void:
	if isColliding and !PlayerStats.DebugMode:
		isColliding = false
		if LevelMan.CanPlayerSave and !alwaysFailToSave:
			$AnimatedSprite2D.play("save")
		else:
			$AnimatedSprite2D.play("bobSave")
	if save:
		save = false
		if LevelMan.CanPlayerSave and !alwaysFailToSave:
			print("[save_point.gd] Saving the game")
			SaveMan.SaveGame(global_position)
			AchievMan.SaveAchievements()
		else:
			$AudioStreamPlayer.stream = load("res://Assets/Audio/SFX/souSaveFail.wav")
		$AudioStreamPlayer.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	save = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name):
		isColliding = true

func _on_audio_stream_player_2d_finished() -> void:
	$AnimatedSprite2D.play("default")
