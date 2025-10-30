extends Camera2D

var maxSmoothSpeed: int = 1000
var isShowingAchievement: bool = false
var targetAchievementPos: Vector2 = Vector2(-99.0, 0.0)
var targetBeansPos: Vector2 = Vector2(13.0, 13.0)
var achievementHidden: bool = true
var achTemplate: String = "[img]res://Assets/Sprites/Achievements/ACHIEVEMENT.png[/img]"
@export var spawnBouncy: TouchScreenButton
@export var deleteBouncy: TouchScreenButton

func _ready() -> void:
	if LevelMan.Os != "Android":
		$CanvasLayer/MobileControls.queue_free()


func _physics_process(delta: float) -> void:
	var node: Node2D = NovaFunc.GetPlayerFromGroup(PlayerStats.FollowWho)
	if node != null and !LevelMan.BossFightOn:
		if node.velocity.x > maxSmoothSpeed or node.velocity.y > maxSmoothSpeed:
			position = node.position
		else:
			position = lerp(position, node.position, 6.0 * delta)
	else:
		var player: Node2D = get_tree().get_first_node_in_group("players")
		if player != null:
			PlayerStats.FollowWho = player.name
	zoom = lerp(zoom, LevelMan.CamZoom, 6.0 * delta)
	
	if Input.is_action_pressed("FencyCam") and NovaFunc.GetPlayerFromGroup("Fency") != null:
		PlayerStats.FollowWho = "Fency"
	elif Input.is_action_pressed("PanLoduwkaCam") and NovaFunc.GetPlayerFromGroup("PanLoduwka") != null:
		PlayerStats.FollowWho = "PanLoduwka"
	elif Input.is_action_just_pressed("ToastyCam") and NovaFunc.GetPlayerFromGroup("Toasty") != null:
		PlayerStats.FollowWho = "Toasty"
	elif Input.is_action_just_pressed("SwitchPlayer"):
		var alivePlayers: Array = get_tree().get_nodes_in_group("players")
		if alivePlayers.size() > 1:
			var currentPlayerIndex: int = alivePlayers.find(NovaFunc.GetPlayerFromGroup(PlayerStats.FollowWho))
			if currentPlayerIndex != -1:
				var nextPlayerIndex: int = (currentPlayerIndex + 1) % alivePlayers.size()
				PlayerStats.FollowWho = alivePlayers[nextPlayerIndex].name
	
	if LevelMan.Os == "Android":
		if !PlayerStats.DebugMode:
			spawnBouncy.visible = false
			deleteBouncy.visible = false
		else:
			spawnBouncy.visible = true
			deleteBouncy.visible = true
	
	if $CanvasLayer/Achievement.position != targetAchievementPos:
		$CanvasLayer/Achievement.position = lerp($CanvasLayer/Achievement.position, targetAchievementPos, 0.1)
	if $CanvasLayer/Beans.position != targetBeansPos:
		$CanvasLayer/Beans.position = lerp($CanvasLayer/Beans.position, targetBeansPos, 0.1)
	
	$CanvasLayer/Beans.text = "Beans: " + str(PlayerStats.GetBeans())
	
	if PlayerStats.SpeedrunMode:
		$CanvasLayer/SpeedrunTimer.show()
		$CanvasLayer/SpeedrunTimer.text = str(LevelMan.SpeedrunTimer["Hours"]) + ":" + str(LevelMan.SpeedrunTimer["Minutes"]) + ":" + str(LevelMan.SpeedrunTimer["Seconds"]) + ":" + str(LevelMan.SpeedrunTimer["Frames"])
	
	if LevelMan.BossFightOn:
		position = lerp(position, LevelMan.BossCamPos, 9.0 * delta)
	
	if achievementHidden and AchievMan.AchievementsToShow != []:
		_showAchievements(AchievMan.AchievementsToShow.pop_front())
	
	if Input.is_action_just_pressed("HealMenu"):
		$HealMenu.show()

func _showAchievements(ach: String) -> void:
	var achievement: String = achTemplate.replace("ACHIEVEMENT", ach)
	achievementHidden = false
	targetAchievementPos = Vector2(0.0, 0.0)
	targetBeansPos = Vector2(13.0, 45.0)
	$CanvasLayer/Achievement.text = achievement
	$AudioStreamPlayer.stream = load(AchievMan.AchievementSound)
	if AchievMan.AchievementSound == "res://Assets/Audio/SFX/souTOASTAch.wav":
		$AudioStreamPlayer.volume_db = 30
	$AudioStreamPlayer.play()
	await get_tree().create_timer(4.0).timeout
	targetAchievementPos = Vector2(-99.0, 0.0)
	targetBeansPos = Vector2(13.0, 13.0)
	await get_tree().create_timer(1.0).timeout
	$CanvasLayer/Achievement.text = ""
	achievementHidden = true


func _on_jump_button_pressed() -> void:
	PlayerStats.MobileJump = 1


func _on_jump_button_released() -> void:
	PlayerStats.MobileJump = 0
