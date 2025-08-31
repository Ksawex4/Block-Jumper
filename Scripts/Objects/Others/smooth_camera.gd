extends Camera2D

var maxSmoothSpeed = 1000
var playerControls
var isShowingAchievement := false
var targetAchievementPos := Vector2(-452, -200)
var targetBeansPos := Vector2(-347, -198)
var achievementHidden = true
var achTemplate = "[img]res://Assets/Sprites/Achievements/ACHIEVEMENT.png[/img]"

func _ready() -> void:
	playerControls = InputMan.AllPlayerControls

func _physics_process(delta: float) -> void:
	var node = NovaFunc.GetPlayerFromGroup(PlayerStats.FollowWho)
	if node != null:
		if node.velocity.x > maxSmoothSpeed or node.velocity.y > maxSmoothSpeed:
			position = node.position
		else:
			position = lerp(position, node.position, 6.0 * delta)
	else:
		var player = get_tree().get_first_node_in_group("players")
		if player != null:
			PlayerStats.FollowWho = player.name
	
	if LevelMan.Os != "Android":
		if Input.is_key_pressed(playerControls["Fency"]["cam"]) and NovaFunc.GetPlayerFromGroup("Fency") != null:
			PlayerStats.FollowWho = "Fency"
		elif Input.is_key_pressed(playerControls["PanLoduwka"]["cam"]) and NovaFunc.GetPlayerFromGroup("PanLoduwka") != null:
			PlayerStats.FollowWho = "PanLoduwka"
		elif Input.is_key_pressed(playerControls["Toasty"]["cam"]) and NovaFunc.GetPlayerFromGroup("Toasty") != null:
			PlayerStats.FollowWho = "Toasty"
	elif Input.is_action_just_pressed("SwitchPlayer"):
		var alivePlayers = get_tree().get_nodes_in_group("players")
		if alivePlayers.size() > 1:
			var currentPlayerIndex = alivePlayers.find(NovaFunc.GetPlayerFromGroup(PlayerStats.FollowWho))
			if currentPlayerIndex != -1:
				var nextPlayerIndex = (currentPlayerIndex + 1) % alivePlayers.size()
				PlayerStats.FollowWho = alivePlayers[nextPlayerIndex].name
	
	if LevelMan.Os == "Android":
		if !PlayerStats.DebugMode:
			$MobileControls/SpawnBouncy.visible = false
			$MobileControls/DeleteBouncy.visible = false
		else:
			$MobileControls/SpawnBouncy.visible = true
			$MobileControls/DeleteBouncy.visible = true
	
	if $Achievement.position != targetAchievementPos:
		$Achievement.position = lerp($Achievement.position, targetAchievementPos, 0.1)
	if $Beans.position != targetBeansPos:
		$Beans.position = lerp($Beans.position, targetBeansPos, 0.1)
	
	$Beans.text = "Beans: " + str(PlayerStats.GetBeans())
	
	if achievementHidden and AchievMan.AchievementsToShow != []:
		_showAchievements(AchievMan.AchievementsToShow.pop_front())

func _showAchievements(ach):
	var achievement = achTemplate.replace("ACHIEVEMENT", ach)
	achievementHidden = false
	targetAchievementPos = Vector2(-355, -200)
	targetBeansPos = Vector2(-347, -166)
	$Achievement.text = achievement
	$AudioStreamPlayer.stream = load(AchievMan.AchievementSound)
	if AchievMan.AchievementSound == "res://Assets/Audio/SFX/souTOASTAch.wav":
		$AudioStreamPlayer.volume_db = 30
	$AudioStreamPlayer.play()
	await get_tree().create_timer(4.0).timeout
	targetAchievementPos = Vector2(-452, -200)
	targetBeansPos = Vector2(-347, -198)
	await get_tree().create_timer(1.0).timeout
	$Achievement.text = ""
	achievementHidden = true
