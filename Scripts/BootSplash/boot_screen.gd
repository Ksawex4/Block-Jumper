extends Node2D

var TargetCamPos: Vector2 = Vector2(0,0)
var TargetBlockPos: Vector2 = Vector2(550.0, -28.0)
var TargetJumperPos: Vector2 = Vector2(-417.0, 52.0)
var BobsSpin := false
var FadeAway := false
var PlayersWalk := false
var Continue := false
var explodedPlayers := 0

func _ready() -> void:
	SaveMan.LoadSettings()
	if LevelMan.Os == "Android" and not LevelMan.IsWeb and !DirAccess.dir_exists_absolute(SaveMan.AndroidSaveDirectory):
		$Information.visible = true
		await get_tree().create_timer(7).timeout
		if !DirAccess.dir_exists_absolute(SaveMan.AndroidSaveDirectory):
			var error: Error = DirAccess.make_dir_recursive_absolute(SaveMan.AndroidSaveDirectory)
			if error == OK:
				print("[boot_screen.gd] Created Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Nova-Games/")
			else:
				print("[boot_screen.gd] Failed to create Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Nova-Games/")
	$AnimatedSprite2D.play("default")
	NovaFunc.ResetAllGlobalsToDefault(true, false)

func _physics_process(_delta: float) -> void:
	$Camera2D.position = lerp($Camera2D.position, TargetCamPos, 0.05)
	$Block.position = lerp($Block.position, TargetBlockPos, 0.05)
	$Jumper.position = lerp($Jumper.position, TargetJumperPos, 0.05)
	if FadeAway:
		if $AnimatedSprite2D.modulate.a != 0.0:
			$AnimatedSprite2D.modulate.a -= 0.05
	if Continue or explodedPlayers >= 3:
		if has_node("Explosion"):
			$Explosion.play("default")
		TargetBlockPos.x = 0.0
		TargetJumperPos.x = 0.0
	if round($Camera2D.position.y) == 888:
		if !BobMan.FailToLoad:
			LevelMan.ChangeLevel("title_screen")
		else:
			$FailedToLoad.show()

func _on_animated_sprite_2d_animation_finished() -> void:
	FadeAway = true
	BobsSpin = true
	await get_tree().create_timer(1.5).timeout
	PlayersWalk = true

func _on_explosion_animation_finished() -> void:
	$Explosion.queue_free()
	await get_tree().create_timer(0.5).timeout
	TargetCamPos.y = 888
