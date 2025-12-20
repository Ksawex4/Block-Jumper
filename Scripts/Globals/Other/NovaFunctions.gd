extends Node


func get_node_from_group(node_name: String, group_name: String="players") -> Node:
	var all_nodes: Array = get_tree().get_nodes_in_group(group_name)
	if all_nodes:
		for node in all_nodes:
			if node.name == node_name:
				return node
		return
	else:
		return

func get_nearest_player(global_position: Vector2) -> CharacterBody2D:
	var players := get_tree().get_nodes_in_group("players")
	var nearestDistance: float = -1
	var nearestPlayer: Node2D
	if players:
		for player in players:
			var d: float = player.global_position.distance_squared_to(global_position)
			if d < nearestDistance or nearestDistance == -1:
				nearestDistance = d
				nearestPlayer = player
	return nearestPlayer


func reset_all_variables_to_default(reset_achievements: bool=false, reset_controls: bool=false, reset_player_stats: bool=false, reset_settings: bool=false, reset_flying: bool=false, reset_speedrun: bool=false) -> void:
	DebugMan.dprint("[NovaFunc, reset_all_variables_to_default] Began")
	AchievMan.reset_variables_to_default(reset_achievements)
	BobMan.reset_variables_to_default()
	DebugMan.reset_variables_to_default()
	GameMan.reset_variables_to_default(reset_speedrun)
	InputMan.reset_variables_to_default(reset_controls)
	LevelMan.reset_variables_to_default(reset_flying)
	PlayerStats.reset_variables_to_default(reset_player_stats)
	SettingsMan.reset_variables_to_default(reset_settings)
	DebugMan.dprint("[NovaFunc, reset_all_variables_to_default] Finished")
