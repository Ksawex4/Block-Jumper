extends Window

func _ready() -> void:
	update_hp_labels()
	SignalMan.connect("UpdateBars", Callable(self, "update_hp_labels"))

func healPlayer(player) -> void:
	if PlayerStats.Beans > 0:
		PlayerStats.AddBeans(-1)
		PlayerStats.Heal(player, 20)

func _on_fency_pressed() -> void:
	healPlayer("Fency")
	update_hp_labels()

func _on_toasty_pressed() -> void:
	healPlayer("Toasty")
	update_hp_labels()

func _on_pan_loduwka_pressed() -> void:
	healPlayer("PanLoduwka")
	update_hp_labels()

func _on_close_requested() -> void:
	hide()

func update_hp_labels() -> void:
	$FencyHP.text = str(PlayerStats.AllPlayerStats["Fency"]["HP"]) + "/" + str(PlayerStats.AllPlayerStats["Fency"]["MaxHP"])
	$PanLoduwkaHP.text = str(PlayerStats.AllPlayerStats["PanLoduwka"]["HP"]) + "/" + str(PlayerStats.AllPlayerStats["PanLoduwka"]["MaxHP"])
	$ToastyHP.text = str(PlayerStats.AllPlayerStats["Toasty"]["HP"]) + "/" + str(PlayerStats.AllPlayerStats["Toasty"]["MaxHP"])
