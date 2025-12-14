extends Window

var Toast: int = -1
var Spawn := false

func _on_toast_text_submitted(new_text: String) -> void:
	Toast = int(new_text)
	$Toast.text = ""
	$Toast/Label.text = str(Toast)


func _on_saltniczka_pressed() -> void:
	Spawn = not Spawn
	$Saltniczka/Label.text = str(Spawn)


func _on_start_pressed() -> void:
	ToastEventMan.Toast = Toast
	LevelMan.Spawn_flying_thing = Spawn
	hide()
	GameMan.Speedrun_mode = true


func _on_close_requested() -> void:
	hide()
