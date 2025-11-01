extends Node

var AllPlayerStats: Dictionary = {
	"Fency": {"HP": 80, "MaxHP": 80, "Stick": false, "StickType": "Normal", "xSpeed": 9000.0, "JumpHeight": -430.0},
	"PanLoduwka": {"HP": 100, "MaxHP": 100, "Stick": false, "StickType": "Normal", "xSpeed": 9000.0, "JumpHeight": -380.0},
	"Toasty": {"HP": 80, "MaxHP": 80, "Stick": false, "StickType": "Normal", "xSpeed": 9000.0, "JumpHeight": -530.0}
}
var Beans: int = 0
var FollowWho: String = "Fency"
var Chip: bool = false
var DebugMode: bool = false
var DuckPlayers: Array = []
var JoystickPosVector: Vector2 = Vector2.ZERO
var SpeedrunMode: bool = false
var SpeedrunModeRandomSaltniczka: bool = true
var MobileJump: int = 0

func _ready() -> void:
	print("[PlayerStats.gd] Loaded")

func Hurt(player: String, damage: int) -> bool:
	if AllPlayerStats.has(player):
		AllPlayerStats[player]["HP"] -= damage
		SignalMan.emit_signal("UpdateBars")
		return true
	else:
		return false

func Heal(player: String, amount: int) -> void:
	if AllPlayerStats.has(player):
		AllPlayerStats[player]["HP"] += amount
		if AllPlayerStats[player]["HP"] > AllPlayerStats[player]["MaxHP"]:
			AllPlayerStats[player]["HP"] = AllPlayerStats[player]["MaxHP"]
		SignalMan.emit_signal("UpdateBars")

func IsPlayerAlive(player: String, checkIfOtherAlive: bool=true) -> bool:
	if AllPlayerStats.has(player):
		var alive: bool = AllPlayerStats[player]["HP"] > 0
		if !alive and checkIfOtherAlive:
			CheckIfAnyoneIsAlive()
		return alive
	else:
		return false

func CheckIfAnyoneIsAlive() -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	var stats: Array = []
	for player: Node2D in players:
		stats.append(IsPlayerAlive(player.name,false))
	if true in stats:
		return
	else:
		print("[PlayerStats.gd] All Players died")
		NovaFunc.ResetAllGlobalsToDefault(true, false)
		SignalMan.emit_signal("ChangedLevel")
		LevelMan.ChangeLevel("title_screen")

func AddBeans(count: int) -> void:
	Beans += count

func GetBeans() -> int:
	return Beans

func GetPlayerStats(player: String) -> Variant:
	if AllPlayerStats.has(player):
		return AllPlayerStats[player]
	else:
		return null

func ResetVariablesToDefault(resetPlayerStats: bool = false) -> void:
	if resetPlayerStats:
		AllPlayerStats = {
			"Fency": {"HP": 80, "MaxHP": 80, "Stick": false, "StickType": "Normal", "xSpeed": 9000.0, "JumpHeight": -430.0},
			"PanLoduwka": {"HP": 100, "MaxHP": 100, "Stick": false, "StickType": "Normal", "xSpeed": 9000.0, "JumpHeight": -380.0},
			"Toasty": {"HP": 80, "MaxHP": 80, "Stick": false, "StickType": "Normal", "xSpeed": 9000.0, "JumpHeight": -530.0}
		}
	Beans = 0
	FollowWho = "Fency"
	Chip = false
	DebugMode = false
	DuckPlayers = []

func IsPlayerDuck(playerName: String) -> bool:
	if DuckPlayers.has(playerName):
		return true
	return false

func AddPlayerDuck(playerName: String) -> void:
	DuckPlayers.append(playerName)
