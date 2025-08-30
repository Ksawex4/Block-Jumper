extends Window

var text = "[color=yellow]Your current achievements ACH/7:[/color]\n"
var achTemplate = "[img]res://Assets/Sprites/Achievements/ACHIEVEMENT.png[/img]\n"

func _ready() -> void:
	SignalMan.connect("ShowAchievements", Callable(self, "_show_achievements"))
	SignalMan.connect("UpdateAchievements", Callable(self, "_update_achievements"))

func _on_close_requested() -> void:
	hide()

func _show_achievements():
	show()
	_update_achievements()

func _update_achievements():
	$RichTextLabel.text = text.replace("ACH", str(AchievMan.Achievements.size()))
	for x in AchievMan.Achievements:
		$RichTextLabel.text += achTemplate.replace("ACHIEVEMENT", x)

func _on_reset_achievements_pressed() -> void:
	AchievMan.ResetVariablesToDefault(true)
