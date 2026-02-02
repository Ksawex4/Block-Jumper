extends Node2D

var TargetCamPos: Vector2 = Vector2.ZERO
var TargetBlockPos: Vector2 = Vector2(550.0, -28.0)
var TargetJumperPos: Vector2 = Vector2(-417.0, 52.0)
@export var BootSplashPlayer: AnimatedSprite2D
@export var BlockNode: Sprite2D
@export var JumperNode: Sprite2D
@export var Camera: Camera2D
@export var FailedToLoadWindow: Window
signal BobsSpin()
signal PlayersMove()
var BootSplashPlayerFinished: bool = false
var ExplodedPlayers: int = 0
signal PlayerExploded()
signal ShowGameTitle()


func _ready() -> void:
	NovaFunc.reset_all_variables_to_default()
	SettingsMan.load_settings()
	AchievMan.load_achievements()
	BobMan.load_bobs_from_filah()
	DebugMan.dprint("[boot_screen.gd, _ready] done")
	
	PlayerExploded.connect(player_exploded)
	ShowGameTitle.connect(finish)
	BootSplashPlayer.play("default")
	await BootSplashPlayer.animation_finished
	BootSplashPlayerFinished = true
	BobsSpin.emit()
	await get_tree().create_timer(1.7).timeout
	PlayersMove.emit()


func player_exploded() -> void:
	ExplodedPlayers += 1
	if ExplodedPlayers >= 3:
		ShowGameTitle.emit()


func _physics_process(delta: float) -> void:
	Camera.position = lerp(Camera.position, TargetCamPos, 3.0 * delta)
	BlockNode.position = lerp(BlockNode.position, TargetBlockPos, 3.0 * delta)
	JumperNode.position = lerp(JumperNode.position, TargetJumperPos, 3.0 * delta)
	
	if BootSplashPlayerFinished and BootSplashPlayer.modulate.a != 0.0:
		BootSplashPlayer.modulate.a -= 0.05 * 60 * delta
	
	
	if round(Camera.position.y) == 888:
		if !BobMan.Fail_to_load:
			LevelMan.change_level("title_screen.tscn")
		else:
			FailedToLoadWindow.show()


func finish() -> void:
	TargetBlockPos.x = 0.0
	TargetJumperPos.x = 0.0
	await get_tree().create_timer(1.5).timeout
	TargetCamPos.y = 888.0
