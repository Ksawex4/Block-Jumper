extends Node

func GetPlayerFromGroup(playerName: String):
	var allPlayers = get_tree().get_nodes_in_group("players")
	if allPlayers:
		for player in allPlayers:
			if player.name == playerName:
				return player
		return null
	else:
		push_warning("players group does not exist in current scene")

func ResetAllGlobalsToDefault(resetControls, resetPlayerStats, resetAchievements) -> void:
	AchievMan.ResetVariablesToDefault(resetAchievements)
	InputMan.ResetVariablesToDefault(resetControls)
	LevelMan.ResetVariablesToDefault()
	PlayerStats.ResetVariablesToDefault(resetPlayerStats)
	ToastEventMan.ResetVariablesToDefault()
