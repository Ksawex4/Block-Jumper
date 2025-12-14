extends Node

enum Events {
	NONE,
	TOAST_ACHIEVEMENT_SOUND,
	SPAM_QUEEN,
	RANDOM_DUCK_PLAYER,
	TOASTY_BEANS,
}
var Toast: int = -1
var Event: Events = Events.NONE
var Spam_queen: bool = false


func get_new_event(toast: int =-1) -> void:
	if not GameMan.Speedrun_mode:
		reset_variables_to_default()
		Toast = randi_range(0,100) if toast == -1 else toast
	match Toast:
		4: Event = Events.TOAST_ACHIEVEMENT_SOUND
		28: Event = Events.SPAM_QUEEN
		37: Event = Events.RANDOM_DUCK_PLAYER
		48: Event = Events.TOASTY_BEANS
		_: Event = Events.NONE


func _process(_delta: float) -> void:
	match Event:
		Events.NONE: pass
		Events.TOAST_ACHIEVEMENT_SOUND:
			if AchievMan.Achievement_sound != "res://Assets/Audio/SFX/sfxTOASTAch.wav":
				AchievMan.change_achievement_sound("res://Assets/Audio/SFX/sfxTOASTAch.wav")
		Events.SPAM_QUEEN:
			Spam_queen = true
		Events.RANDOM_DUCK_PLAYER:
			This_random_player_is_now_A_DUCK()


func This_random_player_is_now_A_DUCK() -> void:
	var players: Array = get_tree().get_nodes_in_group("players")
	if players.size() != 0 and len(PlayerStats.Duck_players) == 0:
		var randomNumber: int = randi_range(1,4)
		var theDuck: Node2D = players.pick_random()
		if theDuck != null and randomNumber != 4:
			PlayerStats.add_duck(theDuck.name)
		elif randomNumber == 4:
			for player: CharacterBody2D in players:
				PlayerStats.add_duck(player.name)


func reset_variables_to_default() -> void:
	if not GameMan.Speedrun_mode:
		Toast = -1
		Event = Events.NONE
		Spam_queen = false
		DebugMan.dprint("[ToastEventMan, reset_variables_to_default] done")
