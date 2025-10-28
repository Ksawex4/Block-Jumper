extends CharacterBody2D

var texter: int = -1
var text: Array = ["PLAYER Get That Chip", "Sodium Chloride"]
var secretText: Array = ["Hello PLAYER, what are you doing here?", "I guess it doesn't matter", "So congrats, You found me", "What are you waiting for?", "I don't give any reward", "...", "...", "You are not just going to leave me here, are you?", "welp...", "I guess i could give you a hint", 'On some hidden achievement in this "Game"', "Just fall", "And wait...", "And if you wait enough, you might meet something", 'Or someone that could give you \nsome hidden "Achievement" you might be searching for', "And if you are still listening", "I wish that you have fun...", "AND don't forget to smash that button \nand ring that bell for more things like this", "So just, go have some fun", "This is all i had to say to you", "Thank you for listening", "So just, go fall, or do anything else", "And im going to sit here", "", "", "", "", "", "", "", "I am spinning right now"]
@export var secretQueen: bool = false
@export var noChip: bool = false
var interractDelay: bool = false
var spin: bool = false

func _ready() -> void:
	if noChip:
		text = ["OH NOOOOOOOOOOOO", "There Is No Chip!!!"]
	if secretQueen:
		text = secretText
		print("[badly_drawn_queen_deltarune.gd, ", self.name ,"] changed text to secret queen text")
	print("[badly_drawn_queen_deltarune.gd, ", self.name ,"] Loaded")

func _physics_process(_delta: float) -> void:
	if spin:
		global_rotation += 0.05

func _on_area_2d_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name) and !interractDelay:
		interractDelay = true
		$Label.text = ""
		if texter < text.size() - 1 and secretQueen or texter < text.size() - 1 and noChip:
			texter += 1
		elif texter == -1 or texter == 0 and PlayerStats.Chip:
			texter += 1
			if PlayerStats.Chip:
				AchievMan.AddAchievement("Chip")
		var currentText: String = text[texter].replace("PLAYER", body.name)
		if currentText == "I am spinning right now" and !spin:
			spin = true
			print("[badly_drawn_queen_deltarune.gd, ", self.name ,"] Started spinning")
		for x: String in currentText:
			$Label.text += x
			await get_tree().process_frame
		interractDelay = false
	
