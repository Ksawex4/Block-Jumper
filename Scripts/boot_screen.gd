extends Node2D

var TargetCamPos = Vector2(0,0)
var TargetBlockPos = Vector2(550.0, -28.0)
var TargetJumperPos = Vector2(-417.0, 52.0)
var storagePermission = "android.permission.WRITE_EXTERNAL_STORAGE"

func _ready() -> void:
	if LevelMan.Os == "Android" and !DirAccess.dir_exists_absolute(SaveMan.AndroidSaveDirectory):
		$Information.visible = true
		await get_tree().create_timer(15).timeout
		if !DirAccess.dir_exists_absolute(SaveMan.AndroidSaveDirectory):
			var error = DirAccess.make_dir_recursive_absolute(SaveMan.AndroidSaveDirectory)
			if error == OK:
				print("created Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Nova-Games/")
			else:
				print("Failed to create Block_Jumper folder in ", OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS) + "/Nova-Games/")
	$AnimatedSprite2D.play("default")
	NovaFunc.ResetAllGlobalsToDefault(false, true, false, true)

func _physics_process(_delta: float) -> void:
	$Camera2D.position = lerp($Camera2D.position, TargetCamPos, 0.05)
	$Block.position = lerp($Block.position, TargetBlockPos, 0.05)
	$Jumper.position = lerp($Jumper.position, TargetJumperPos, 0.05)
	if round($Block.position.x) == 0 and round($Jumper.position.x) == 0:
		TargetCamPos.y = 888
	if round($Camera2D.position.y) == 888:
		if !BobMan.FailToLoad:
			LevelMan.ChangeLevel("res://Scenes/Levels/title_screen.tscn")
		else:
			$FailedToLoad.show()

func _on_animated_sprite_2d_animation_finished() -> void:
	TargetBlockPos.x = 0.0
	TargetJumperPos.x = 0.0
