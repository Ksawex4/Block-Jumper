extends Node

var Toast := -1
var SpamQueen := false
const SpamtonSpritePath = "res://Assets/Sprites/Characters/Enemies/BadlyDrawnSpamton.png"

func _ready() -> void:
	SignalMan.connect("ChangedLevel", Callable(self, "ToastProcessing"))
	GetNewToastAndStartEvent()

func _process(_delta: float) -> void:
	ToastProcessing()
	await get_tree().create_timer(0.2).timeout

func GetNewToastAndStartEvent() -> void:
	Toast = randi_range(0,100)
	ToastProcessing()

func GetToastEvent() -> String:
	match Toast:
		4: return "ToastAchievementSound"
		# 16: "RandomKeys" im not sure about this one
		28: return "SpamQueen"
		37: return "RandomDuckPlayer"
		48: return "ToastyBeans"
		# 54: "RigidPlayer" Not done yet
		_: return ""

func ToastProcessing():
	var event = GetToastEvent()
	await get_tree().create_timer(0.1).timeout
	match event:
		"ToastAchievementSound": AchievMan.ChangeAchievementSound("res://Assets/Audio/SFX/souTOASTAch.wav")
		"SpamQueen": SpamQueens()
		"RandomDuckPlayer": ThisRandomPlayerIsNowADUCK()
		"ToastyBeans": LevelMan.BeansAreToasts = true

func SpamQueens():
	var npcs = get_tree().get_nodes_in_group("npcs")
	if npcs != null:
		for npc in npcs:
			if npc.name == "BadlyDrawnQueenDeltarune":
				var sprite = npc.get_node_or_null("Sprite2D")
				if sprite != null:
					sprite.texture = load(SpamtonSpritePath)

func ThisRandomPlayerIsNowADUCK(): # doesn't work :(
	var randomNumber = randi_range(1,4)
	var players = get_tree().get_nodes_in_group("players")
	if players != null and len(players) != 0 and len(PlayerStats.DuckPlayers) == 0:
		var theDuck = players.pick_random()
		if theDuck != null and randomNumber != 4:
			PlayerStats.AddPlayerDuck(theDuck.name)
		elif randomNumber == 4:
			for player in players:
				PlayerStats.DuckPlayers.append(player.name)
	print(PlayerStats.DuckPlayers, Toast)

func ResetVariablesToDefault() -> void:
	Toast = -1
	SpamQueen = false
