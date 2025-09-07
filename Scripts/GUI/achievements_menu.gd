extends Window

var text: String = "[color=yellow]Your current achievements ACH/8:[/color]\n"
var achTemplate: String = "[img]res://Assets/Sprites/Achievements/ACHIEVEMENT.png[/img]\n"

func _ready() -> void:
	SignalMan.connect("ShowAchievements", Callable(self, "_show_achievements"))
	SignalMan.connect("UpdateAchievements", Callable(self, "_update_achievements"))

func _on_close_requested() -> void:
	hide()

func _show_achievements() -> void:
	show()
	_update_achievements()

func _update_achievements() -> void:
	print("[achievements_menu.gd] Updated achievements label")
	$RichTextLabel.text = text.replace("ACH", str(AchievMan.Achievements.size()))
	for x: String in AchievMan.Achievements:
		$RichTextLabel.text += achTemplate.replace("ACHIEVEMENT", x)

func _on_reset_achievements_pressed() -> void:
	print("[achievements_menu.gd] Reseting achievements")
	AchievMan.ResetVariablesToDefault(true)
