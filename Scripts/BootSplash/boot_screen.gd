extends Node2D

var Target_cam_pos: Vector2 = Vector2(0,0)
var Target_block_pos: Vector2 = Vector2(550.0, -28.0)
var Target_jumper_pos: Vector2 = Vector2(-417.0, 52.0)
var Bobs_spin := false
var Players_walk := false
var Continue := false
var Exploded_players := 0


func _ready() -> void:
	$AnimatedSprite2D.play("default")
	NovaFunc.reset_all_variables_to_default()
	SettingsMan.load_settings()
	AchievMan.load_achievements()
	BobMan.load_bobs_from_filah()
	DebugMan.dprint("[boot_screen.gd, _ready] done")


func _physics_process(_delta: float) -> void:
	$Camera2D.position = lerp($Camera2D.position, Target_cam_pos, 0.05)
	$Block.position = lerp($Block.position, Target_block_pos, 0.05)
	$Jumper.position = lerp($Jumper.position, Target_jumper_pos, 0.05)
	
	if Bobs_spin and $AnimatedSprite2D.modulate.a != 0.0:
		$AnimatedSprite2D.modulate.a -= 0.05
	
	if Continue or Exploded_players >= 3:
		if has_node("Explosion"):
			$Explosion.play("default")
		Target_block_pos.x = 0.0
		Target_jumper_pos.x = 0.0
	
	if round($Camera2D.position.y) == 888:
		if not BobMan.Fail_to_load:
			LevelMan.change_level("title_screen.tscn")
		else:
			$FailedToLoad.show()


func _on_animated_sprite_2d_animation_finished() -> void:
	Bobs_spin = true
	DebugMan.dprint("[boot_screen.gd, _on_animated_sprite_2d_animation_finished] bobs spin")
	await get_tree().create_timer(1.5).timeout
	Players_walk = true
	DebugMan.dprint("[boot_screen.gd, _on_animated_sprite_2d_animation_finished] players walk")


func _on_explosion_animation_finished() -> void:
	$Explosion.queue_free()
	await get_tree().create_timer(0.5).timeout
	DebugMan.dprint("[boot_screen.gd, _on_explosion_animation_finished] Finished")
	Target_cam_pos.y = 888
