extends Area2D

var Texter := -1
@export var Text: Array[String] = ["npc-queen.text.1", "npc-queen.text.2"]
var Secret_text: Array[String] = [
	"npc-queen.secret-text.case1.1",
	"npc-queen.secret-text.case1.2",
	"npc-queen.secret-text.case1.3",
	"npc-queen.secret-text.case1.4",
	"npc-queen.secret-text.case1.5",
	"npc-queen.secret-text.case1.6", "npc-queen.secret-text.case1.6", 
	"npc-queen.secret-text.case1.8",
	"npc-queen.secret-text.case1.9",
	"npc-queen.secret-text.case1.10",
	"npc-queen.secret-text.case1.11",
	"npc-queen.secret-text.case1.12",
	"npc-queen.secret-text.case1.13",
	"npc-queen.secret-text.case1.14",
	"npc-queen.secret-text.case1.15",
	"npc-queen.secret-text.case1.16",
	"npc-queen.secret-text.case1.17",
	"npc-queen.secret-text.case1.18",
	"npc-queen.secret-text.case1.19",
	"npc-queen.secret-text.case1.20",
	"npc-queen.secret-text.case1.21",
	"npc-queen.secret-text.case1.22",
	"", "", "", "", "", "", "",
	"npc-queen.secret-text.spinning"
]
@export var No_chip := false
@export var Secret_queen := false
var Spin := false
var Interact_stop := false

func _ready() -> void:
	if No_chip:
		Text = ["npc-queen.no-chip.1", "npc-queen.no-chip.2"]
	if Secret_queen:
		Text = Secret_text
		if BobMan.Saved_bobs > 0:
			Text = [
				"npc-queen.secret-text.case1.1",
				"npc-queen.secret-text.case1.2",
				"npc-queen.secret-text.case1.3",
				"npc-queen.secret-text.case1.4",
				"npc-queen.secret-text.case1.5",
				"npc-queen.secret-text.case1.6", "npc-queen.secret-text.case1.6", 
				"npc-queen.secret-text.case1.8",
				"npc-queen.secret-text.case1.9",
				"npc-queen.secret-text.case1.10",
				"npc-queen.secret-text.case1.11",
				"npc-queen.secret-text.case2.12",
				"npc-queen.secret-text.case2.13",
				"npc-queen.secret-text.case2.14",
				"npc-queen.secret-text.case2.15",
				"npc-queen.secret-text.case2.16",
				"npc-queen.secret-text.case2.17",
				"npc-queen.secret-text.case2.18",
				"", "", "", "", "", "", "",
				"npc-queen.secret-text.spinning"
				]
		elif BobMan.Saved_bobs < 0:
			Text = [
				"npc-queen.secret-text.case1.1",
				"npc-queen.secret-text.case1.2",
				"npc-queen.secret-text.case1.3",
				"npc-queen.secret-text.case1.4",
				"npc-queen.secret-text.case1.5",
				"npc-queen.secret-text.case1.6", "npc-queen.secret-text.case1.6", 
				"npc-queen.secret-text.case1.8",
				"npc-queen.secret-text.case1.9",
				"npc-queen.secret-text.case1.10",
				"npc-queen.secret-text.case1.11",
				"npc-queen.secret-text.case3.12",
				"npc-queen.secret-text.case3.13",
				"npc-queen.secret-text.case3.14",
				"npc-queen.secret-text.case3.15",
				"npc-queen.secret-text.case3.16",
				"npc-queen.secret-text.case3.17",
				"", "", "", "", "", "", "",
				"npc-queen.secret-text.spinning"
			]
	if ToastEventMan.Spam_queen:
		$Sprite2D.change_texture(&"enemy-badly-drawn-spam-queen")


func _physics_process(_delta: float) -> void:
	if Spin:
		global_rotation += 0.05


func _on_body_entered(body: Node2D) -> void:
	if not Interact_stop:
		Interact_stop = true
		$Label.visible_characters = 0
		$Label.text = ""
		if Texter < Text.size() - 1 and (Secret_queen or No_chip):
			Texter += 1
		elif Texter == -1 or Texter == 0 and PlayerStats.Chip:
			Texter += 1
			if PlayerStats.Chip:
				AchievMan.add_achievement("Chip")
		$Label.text = tr(Text[Texter]).replace("PLAYER", body.name)
		if $Label.text == tr("npc-queen.secret-text.spinning") and not Spin:
			Spin = true
		for x in len($Label.text):
			$Label.visible_characters += 1
			await get_tree().physics_frame
		Interact_stop = false
