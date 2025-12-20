extends Camera2D

var Max_smooth_speed: int = 800
var Achievement_start_pos: Vector2
var Achievement_show_pos := Vector2.ZERO
var Achievement_show := false
var Achievement_hidden := true
var Achievement_template := "[img]res://Assets/Sprites/Achievements/ACHIEVEMENT.png[/img]"
var Beans_start_pos := Vector2.ZERO
var Beans_second_pos := Vector2(0.0, 32.0)
@export var HealMenu: Window
@export var AchievementLabel: RichTextLabel
@export var BeansLabel: Label
signal ShowHealMenu()


func _ready() -> void:
	Achievement_start_pos = AchievementLabel.position
	$AudioStreamPlayer.stream = load(AchievMan.Achievement_sound)
	if AchievMan.Achievement_sound == "res://Assets/Audio/SFX/souTOASTAch.wav":
		$AudioStreamPlayer.volume_db = 10
	if GameMan.is_mobile():
		$CanvasLayer/MobileControls.show()
	else:
		$CanvasLayer/MobileControls.queue_free()


func _physics_process(delta: float) -> void:
	# Camera position and zoom
	if not (SettingsMan.StaticBossCamera and LevelMan.Boss_fight):
		var node: CharacterBody2D = NovaFunc.get_node_from_group(PlayerStats.Follow_who)
		if node:
			if node.velocity.x > Max_smooth_speed or node.velocity.y > Max_smooth_speed:
				position = node.position
			else:
				position = lerp(position, node.position, 6.0 * delta)
		else:
			var player: CharacterBody2D = get_tree().get_first_node_in_group("players")
			if player:
				PlayerStats.Follow_who = player.name
	elif SettingsMan.StaticBossCamera and LevelMan.Boss_fight:
		position = lerp(position, LevelMan.Boss_cam_pos, 6.0 * delta)
	zoom = lerp(zoom, LevelMan.Cam_zoom, 6.0 * delta)
	
	# Camera player changing
	if Input.is_action_just_pressed("FencyCam") and NovaFunc.get_node_from_group("Fency"):
		PlayerStats.Follow_who = "Fency"
	elif Input.is_action_pressed("PanLoduwkaCam") and NovaFunc.get_node_from_group("PanLoduwka") != null:
		PlayerStats.Follow_who = "PanLoduwka"
	elif Input.is_action_just_pressed("ToastyCam") and NovaFunc.get_node_from_group("Toasty") != null:
		PlayerStats.Follow_who = "Toasty"
	elif Input.is_action_just_pressed("SwitchPlayer"):
		var alivePlayers: Array = get_tree().get_nodes_in_group("players")
		if alivePlayers.size() > 1:
			var currentPlayerIndex: int = alivePlayers.find(NovaFunc.get_node_from_group(PlayerStats.Follow_who))
			if currentPlayerIndex != -1:
				var nextPlayerIndex: int = (currentPlayerIndex + 1) % alivePlayers.size()
				PlayerStats.Follow_who = alivePlayers[nextPlayerIndex].name
	
	# Other Input
	if Input.is_action_just_pressed("HealMenu"):
		emit_signal("ShowHealMenu")
	
	# Achievement and Beans labels positions
	var target_pos_a := Achievement_start_pos if not Achievement_show else Achievement_show_pos
	AchievementLabel.position = lerp(AchievementLabel.position, target_pos_a, 6.0 * delta)
	var target_pos_b := Beans_start_pos if not Achievement_show else Beans_second_pos
	BeansLabel.position = lerp(BeansLabel.position, target_pos_b, 6.0 * delta)
	
	if Achievement_hidden and AchievMan.Achievements_to_show.size() > 0:
		_show_achievement(AchievMan.Achievements_to_show.pop_front())
	
	$CanvasLayer/Beans.text = "Beans: %s" % PlayerStats.Beans
	
	if GameMan.Speedrun_mode:
		$CanvasLayer/SpeedrunTimer.show()
		$CanvasLayer/SpeedrunTimer.text = "%s:%s:%.1f" % [GameMan.Speedrun_timer["Hours"], GameMan.Speedrun_timer["Minutes"], GameMan.Speedrun_timer["Seconds"]]
	else:
		$CanvasLayer/SpeedrunTimer.text = "%s:%s:%.3f" % [GameMan.Speedrun_timer["Hours"], GameMan.Speedrun_timer["Minutes"], GameMan.Speedrun_timer["Seconds"]]


func _show_achievement(ach: String) -> void:
	var achievement := AchievMan.Achievement_sprites[ach]
	AchievementLabel.text = ""
	if achievement:
		AchievementLabel.add_image(achievement)
	else:
		AchievementLabel.text = "Everything is fucked," + ach
	Achievement_show = true
	Achievement_hidden = false
	$AudioStreamPlayer.stream = load(AchievMan.Achievement_sound)
	if AchievMan.Achievement_sound == "res://Assets/Audio/SFX/souTOASTAch.wav":
		$AudioStreamPlayer.volume_db = 10
	$AudioStreamPlayer.play()
	await get_tree().create_timer(4.0).timeout
	Achievement_show = false
	await get_tree().create_timer(1.0).timeout
	AchievementLabel.text = ""
	Achievement_hidden = true


func _on_jump_button_pressed() -> void:
	InputMan.Mobile_jump = true


func _on_jump_button_released() -> void:
	InputMan.Mobile_jump = false
