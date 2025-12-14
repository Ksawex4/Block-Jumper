extends Area2D

var Texter := -1
@export var Text: Array[String] = ["PLAYER Get That Chip", "Sodium Chloride"]
var Secret_text: Array[String] = ["Hello PLAYER, what are you doing here?", "I guess it doesn't matter", "So congrats, You found me", "What are you waiting for?", "I don't give any reward", "...", "...", "You are not just going to leave me here, are you?", "welp...", "I guess i could give you a hint", 'On some hidden achievement in this "Game"', "Just fall", "And wait...", "And if you wait enough, you might meet something", 'Or someone that could give you some hidden "Achievement" you might be searching for', "And if you are still listening", "I wish that you have fun...", "AND don't forget to smash that button and ring that bell for more things like this", "So just, go have some fun", "This is all i had to say to you", "Thank you for listening", "So just, go fall, or do anything else", "And im going to sit here", "", "", "", "", "", "", "", "I am spinning right now"]
@export var No_chip := false
@export var Secret_queen := false
var Spin := false
var Interact_stop := false

func _ready() -> void:
	if No_chip:
		Text = ["OH NOOOOOOOOOOOO", "There Is No Chip!!!"]
	if Secret_queen:
		Text = Secret_text
	if ToastEventMan.Spam_queen:
		$Sprite2D.texture = load("uid://cc82e7km5w72n")


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
		$Label.text = Text[Texter].replace("PLAYER", body.name)
		if $Label.text == "I am spinning right now" and not Spin:
			Spin = true
		for x in len($Label.text):
			$Label.visible_characters += 1
			await get_tree().physics_frame
		Interact_stop = false
