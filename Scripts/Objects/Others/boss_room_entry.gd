extends Area2D

@export var door: Node2D
@export var moveDoorHowMuch: Vector2 = Vector2(0,0)
@export var mainLevelMusicPlayer: AudioStreamPlayer
@export var bossMusicPlayer: AudioStreamPlayer
@export var boss: Node2D
@export var cameraSettings := {"Pos": Vector2(0.0 ,0.0), "Zoom": Vector2(1.0, 1.0)}
var doorStartPos := Vector2(0.0, 0.0)
var moveDoor: bool = false
var targetPos: Vector2

func _ready() -> void:
	if door:
		doorStartPos = door.position
		targetPos = door.position + moveDoorHowMuch

func _on_body_entered(_body: Node2D) -> void:
	LevelMan.BossCamPos = cameraSettings["Pos"]
	LevelMan.CamZoom = cameraSettings["Zoom"]
	LevelMan.BossFightOn = true
	set_deferred("monitoring", false)
	moveDoor = true
	await get_tree().create_timer(0.5).timeout
	if mainLevelMusicPlayer:
		mainLevelMusicPlayer.stop()
	if bossMusicPlayer:
		bossMusicPlayer.play()
	boss.startFight()

func _physics_process(_delta: float) -> void:
	if moveDoor and door:
		door.position = lerp(door.position, targetPos, 0.2)

func fightEnded() -> void:
	targetPos = doorStartPos
