extends Window

func _ready() -> void:
	$"..".connect("ShowHealMenu", Callable(self, "show"))
	PlayerStats.connect("StatsChanged", Callable(self, "update_labels"))
	update_labels()

func heal_player(player: String) -> void:
	if PlayerStats.Beans > 0:
		PlayerStats.take_beans(1)
		PlayerStats.heal_player(player, 20)
		update_labels()


func _on_close_requested() -> void:
	hide()


func update_labels() -> void:
	$FencyHP.text = "%s/%s" % [PlayerStats.Player_stats["Fency"].Health, PlayerStats.Player_stats["Fency"].Max_health]
	$PanLoduwkaHP.text = "%s/%s" % [PlayerStats.Player_stats["PanLoduwka"].Health, PlayerStats.Player_stats["PanLoduwka"].Max_health]
	$ToastyHP.text = "%s/%s" % [PlayerStats.Player_stats["Toasty"].Health, PlayerStats.Player_stats["Toasty"].Max_health]
	
