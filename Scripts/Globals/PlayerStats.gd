extends Node

var AllPlayerStats = {
	"Fency": {"HP": 10, "MaxHP": 10, "Stick": true, "xSpeed": 9000.0, "JumpHeight": -430.0},
	"PanLoduwka": {"HP": 20, "MaxHP": 20, "Stick": true, "xSpeed": 9000.0, "JumpHeight": -380.0},
	"Toasty": {"HP": 10, "MaxHP": 10, "Stick": true, "xSpeed": 9000.0, "JumpHeight": -530.0}
}
var Beans := 0
var FollowWho = "Fency"
var Chip = false
var DebugMode = false
var DuckPlayers = []
var JoystickPosVector = Vector2(0,0)

func Hurt(player: String, damage: int):
	if AllPlayerStats.has(player):
		AllPlayerStats[player]["HP"] -= damage
		SignalMan.emit_signal("UpdateBars")
		return "Yup"
	else:
		return null

func IsPlayerAlive(player: String, checkIfOtherAlive: bool=true):
	if AllPlayerStats.has(player):
		var alive = AllPlayerStats[player]["HP"] > 0
		if !alive and checkIfOtherAlive:
			CheckIfAnyoneIsAlive()
		return alive
	else:
		return null

func CheckIfAnyoneIsAlive():
	var players = get_tree().get_nodes_in_group("players")
	var stats = []
	for player in players:
		stats.append(IsPlayerAlive(player.name,false))
	if true in stats:
		return
	else:
		NovaFunc.ResetAllGlobalsToDefault(false, true, false, false)
		SignalMan.emit_signal("ChangedLevel")
		LevelMan.ChangeLevel("res://Scenes/Levels/title_screen.tscn")

func AddBeans(count: int) -> void:
	Beans += count

func GetBeans() -> int:
	return Beans

func GetPlayerStats(player: String):
	if AllPlayerStats.has(player):
		return AllPlayerStats[player]
	else:
		return null

func ResetVariablesToDefault(resetPlayerStats: bool = false) -> void:
	if resetPlayerStats:
		AllPlayerStats = {
			"Fency": {"HP": 10, "MaxHP": 10, "Stick": true, "xSpeed": 9000.0, "JumpHeight": -430.0},
			"PanLoduwka": {"HP": 20, "MaxHP": 20, "Stick": true, "xSpeed": 9000.0, "JumpHeight": -380.0},
			"Toasty": {"HP": 10, "MaxHP": 10, "Stick": true, "xSpeed": 9000.0, "JumpHeight": -530.0}
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
