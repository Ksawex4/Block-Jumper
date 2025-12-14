extends Node

var Player_stats: Dictionary[String, Player] = {
	"Fency": load("uid://6fk1uio5cv8b").duplicate(),
	"PanLoduwka": load("uid://6upgvya1fwk0").duplicate(),
	"Toasty": load("uid://piff6rltxskb").duplicate(),
}
var Beans: int = 0
## who the camera follows
var Follow_who: String = "Fency"
var Chip := false
var Player_ducks: Array[String] = []
signal StatsChanged()

func get_save_data() -> Dictionary:
	return {
		"Fency": Player_stats["Fency"].get_save_data(),
		"PanLoduwka": Player_stats["PanLoduwka"].get_save_data(),
		"Toasty": Player_stats["Toasty"].get_save_data()
	}


func load_save_data(data: Dictionary):
	if data:
		if data["Fency"]:
			Player_stats["Fency"].load_stats(data["Fency"])
		if data["PanLoduwka"]:
			Player_stats["PanLoduwka"].load_stats(data["PanLoduwka"])
		if data["Toasty"]:
			Player_stats["Toasty"].load_stats(data["Toasty"])
		DebugMan.dprint("[PlayerStats, load_save_data] done ", data)


func is_player_alive(player_name: String) -> bool:
	return Player_stats[player_name].is_alive()


func is_any_player_alive() -> bool:
	for x in Player_stats.keys():
		if Player_stats[x].is_alive():
			return true
	if  get_tree().get_nodes_in_group("players").size() > 0:
		return true
	return false


func add_beans(amount: int) -> void:
	Beans += amount


func take_beans(amount: int) -> void:
	Beans -= amount


func hurt_player(player_name: String, damage: int) -> void:
	if Player_stats.has(player_name):
		Player_stats[player_name].hurt(damage)
		DebugMan.dprint("[PlayerStats, heal_player] hurt ", damage, player_name)


func heal_player(player_name: String, amount: int) -> void:
	print("")
	if Player_stats.has(player_name):
		Player_stats[player_name].heal(amount)
		DebugMan.dprint("[PlayerStats, heal_player] healed ", amount, player_name)


func used_stick(player_name: String) -> void:
	if Player_stats.has(player_name):
		Player_stats[player_name].Stick = Player.StickType.NONE


func has_stick(player_name: String) -> bool:
	if Player_stats.has(player_name):
		return Player_stats[player_name].has_stick()
	return false


func add_stick(player_name: String, stick_type: Player.StickType) -> void:
	if Player_stats.has(player_name):
		Player_stats[player_name].Stick = stick_type
	else:
		push_warning('player "' + player_name + '" doesn\'t exist in Player_stats')


func add_duck(player_name: String) -> void:
	if not Player_ducks.has(player_name):
		Player_ducks.append(player_name)


func is_player_duck(player_name: String) -> bool:
	return Player_ducks.has(player_name)


func reset_variables_to_default(reset: bool) -> void:
	if reset:
		Player_stats = {
			"Fency": load("uid://6fk1uio5cv8b").duplicate(),
			"PanLoduwka": load("uid://6upgvya1fwk0").duplicate(),
			"Toasty": load("uid://piff6rltxskb").duplicate(),
		}
		Beans = 0
		Chip = false
	Follow_who = "Fency"
	Player_ducks = []
	DebugMan.dprint("[PlayerStats, reset_variables_to_default] done ", reset)
