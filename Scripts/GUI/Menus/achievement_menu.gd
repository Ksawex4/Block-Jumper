extends Window

var Text: String = "[color=yellow]Your current achievements ACH/" + str(AchievMan.Amount_of_achievements) + ":[/color]\n"
#var Ach_template: String = "res://Assets/Sprites/Achievements/ACHIEVEMENT.png"


func _ready() -> void:
	AchievMan.connect("ShowAchievements", Callable(self, "show_achievements"))
	AchievMan.connect("UpdateAchievements", Callable(self, "update_achievements"))
	update_achievements()


func _on_close_requested() -> void:
	hide()


func _on_reset_achievements_pressed() -> void:
	AchievMan.reset_variables_to_default(true)


func show_achievements() -> void:
	show()

func update_achievements() -> void:
	$RichTextLabel.text = Text.replace("ACH", str(AchievMan.Achievements.size()))
	for x: String in AchievMan.Achievements:
		$RichTextLabel.add_image(AchievMan.Achievement_sprites[x])
	
	DebugMan.dprint("[achievements_menu, update_achievements] done")
