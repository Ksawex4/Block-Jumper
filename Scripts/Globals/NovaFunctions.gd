extends Node

func _ready() -> void:
	print("[NovaFunctions.gd] Loaded")

func GetPlayerFromGroup(playerName: String) -> Node2D:
	var allPlayers: Array = get_tree().get_nodes_in_group("players")
	if allPlayers:
		for player: Node2D in allPlayers:
			if player.name == playerName:
				return player
		return
	else:
		return

func ResetAllGlobalsToDefault(resetPlayerStats: bool=false, resetAchievements: bool=false) -> void:
	print("[NovaFunctions.gd] Reseting all variables, PlayerStats: ", resetPlayerStats, ", Achievements: ", resetAchievements)
	AchievMan.ResetVariablesToDefault(resetAchievements)
	InputMan.ResetVariablesToDefault()
	LevelMan.ResetVariablesToDefault()
	PlayerStats.ResetVariablesToDefault(resetPlayerStats)
	ToastEventMan.ResetVariablesToDefault()
