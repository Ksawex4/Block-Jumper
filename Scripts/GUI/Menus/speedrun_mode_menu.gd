extends Window

var Toast: int = -1
var Spawn := true

func _on_toast_text_submitted(new_text: String) -> void:
	Toast = int(new_text)
	$Toast.text = ""
	$Toast/Label.text = str(Toast)


func _on_saltniczka_pressed() -> void:
	Spawn = not Spawn
	$Saltniczka/Label.text = str(Spawn)


func _on_start_pressed() -> void:
	ToastEventMan.Toast = Toast
	GameMan.reset_variables_to_default(true)
	GameMan.Random_saltniczka = Spawn
	hide()
	AchievMan.reset_variables_to_default(true)
	GameMan.Speedrun_mode = true
	LevelMan.change_level("title_screen.tscn")


func _on_close_requested() -> void:
	hide()
