extends Window

func healPlayer(player) -> void:
	if PlayerStats.Beans > 0:
		PlayerStats.AddBeans(-1)
		PlayerStats.Heal(player, 20)

func _on_fency_pressed() -> void:
	healPlayer("Fency")

func _on_toasty_pressed() -> void:
	healPlayer("Toasty")

func _on_pan_loduwka_pressed() -> void:
	healPlayer("PanLoduwka")

func _on_close_requested() -> void:
	hide()
