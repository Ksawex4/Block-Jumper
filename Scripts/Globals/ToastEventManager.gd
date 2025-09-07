extends Node

var Toast: int = -1
var SpamQueen: bool = false
const SpamtonSpritePath: String = "res://Assets/Sprites/Characters/Enemies/BadlyDrawnSpamton.png"

func _ready() -> void:
	SignalMan.connect("ChangedLevel", Callable(self, "ToastProcessing"))
	GetNewToastAndStartEvent()
	print("[ToastEventManager.gd] Loaded")

func _process(_delta: float) -> void:
	ToastProcessing()
	await get_tree().create_timer(0.2).timeout

func GetNewToastAndStartEvent() -> void:
	Toast = randi_range(0,100)
	print("[ToastEventManager.gd] Got toast ", Toast)
	ToastProcessing()

func GetToastEvent() -> String:
	match Toast:
		4: return "ToastAchievementSound"
		28: return "SpamQueen"
		37: return "RandomDuckPlayer"
		48: return "ToastyBeans"
		# 54: "RigidPlayer" Not done yet
		_: return ""

func ToastProcessing() -> void:
	var event: String = GetToastEvent()
	await get_tree().create_timer(0.1).timeout
	match event:
		"ToastAchievementSound": AchievMan.ChangeAchievementSound("res://Assets/Audio/SFX/souTOASTAch.wav")
		"SpamQueen": SpamQueens()
		"RandomDuckPlayer": ThisRandomPlayerIsNowADUCK()
		"ToastyBeans": LevelMan.BeansAreToasts = true

func SpamQueens() -> void:
	var npcs: Array = get_tree().get_nodes_in_group("npcs")
	if npcs:
		for npc: Node2D in npcs:
			if npc.name == "BadlyDrawnQueenDeltarune":
				var sprite: Node2D = npc.get_node_or_null("Sprite2D")
				if sprite != null:
					sprite.texture = load(SpamtonSpritePath)

func ThisRandomPlayerIsNowADUCK() -> void:
	var randomNumber: int = randi_range(1,4)
	var players: Array = get_tree().get_nodes_in_group("players")
	if players and len(players) != 0 and len(PlayerStats.DuckPlayers) == 0:
		var theDuck: Node2D = players.pick_random()
		if theDuck != null and randomNumber != 4:
			PlayerStats.AddPlayerDuck(theDuck.name)
		elif randomNumber == 4:
			for player: Node2D in players:
				PlayerStats.DuckPlayers.append(player.name)
	print(PlayerStats.DuckPlayers, Toast)

func ResetVariablesToDefault() -> void:
	Toast = -1
	SpamQueen = false
	print("[ToastEventManager.gd] Reseted variables")
