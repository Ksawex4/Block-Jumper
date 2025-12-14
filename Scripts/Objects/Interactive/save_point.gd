extends CharacterBody2D

@export var Always_fail_to_save: bool = false
var Is_colliding: int = 0
var Saved := false
var Save: bool = false
var Save_fail_SFX := preload("uid://dneayfxwqines")


func _ready() -> void:
	$AnimatedSprite2D.play("default")


func _process(_delta: float) -> void:
	if Is_colliding > 0 and not Saved and not DebugMan.Debug_mode:
		Saved = true
		if LevelMan.Can_player_save and not Always_fail_to_save:
			$AnimatedSprite2D.play("save")
			DebugMan.dprint("["+ name +", _process] will save")
		else:
			$AnimatedSprite2D.play("bobSave")
			DebugMan.dprint("["+ name +", _process] will fail")
	if Save:
		Save = false
		if LevelMan.Can_player_save and not Always_fail_to_save:
			GameMan.save_game(position)
			AchievMan.save_achievements()
		else:
			$AudioStreamPlayer.stream = Save_fail_SFX
		$AudioStreamPlayer.play()
	
	if (
		Is_colliding and Input.is_action_just_pressed("Interact") 
		and BobMan.Saved_bobs <= 0 and not Always_fail_to_save
	):
		if LevelMan.Can_quit_level:
			NovaFunc.reset_all_variables_to_default(false, false, true)
			GameMan.load_game()


func _on_animated_sprite_2d_animation_finished() -> void:
	Save = true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	Is_colliding += 1
	Saved = false
	if not Always_fail_to_save and BobMan.Saved_bobs <= 0:
		$Label.show()


func _on_audio_stream_player_2d_finished() -> void:
	$AnimatedSprite2D.play("default")


func _on_area_2d_body_exited(_body: Node2D) -> void:
	Is_colliding -= 1
	if Is_colliding <= 0:
		$Label.hide()
