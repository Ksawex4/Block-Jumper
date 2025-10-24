extends CharacterBody2D

var isColliding: bool = false
var saved := false
var save: bool = false
@export var alwaysFailToSave: bool = false
var saveFailSFX := preload("uid://dneayfxwqines")

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(_delta: float) -> void:
	if isColliding and not saved and !PlayerStats.DebugMode:
		saved = true
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
			$AudioStreamPlayer.stream = saveFailSFX
		$AudioStreamPlayer.play()
	
	if isColliding and Input.is_action_just_pressed("Interract"):
		NovaFunc.ResetAllGlobalsToDefault(true, false)
		SaveMan.LoadGame()

func _on_animated_sprite_2d_animation_finished() -> void:
	save = true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	isColliding = true
	saved = false
	$Label.visible = true

func _on_audio_stream_player_2d_finished() -> void:
	$AnimatedSprite2D.play("default")


func _on_area_2d_body_exited(_body: Node2D) -> void:
	isColliding = false
	$Label.visible = false
