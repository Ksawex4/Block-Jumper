extends Area2D

@export var LevelPath: String = "boot_screen"
@export var ChangeLevel: bool = true
@export var Position: Vector2 = Vector2(0,0)
@export var WhichPlayers := ["Fency", "PanLoduwka", "Toasty"]
@export var ShowInfo := false

func _ready() -> void:
	if len(WhichPlayers) != 3 and ShowInfo:
		$Label.show()
		$Label.text = "Can Only teleport:\n"
		for x in WhichPlayers:
			$Label.text += x + " "

func _on_body_entered(body: Node2D) -> void:
	if body.whoAmI in WhichPlayers:
		if ChangeLevel:
			print("[level_changer.gd] Changing level to ", LevelPath)
			LevelMan.ChangeLevel(LevelPath)
		else:
			print("[level_changer.gd] Teleporting Player to ", Position)
			body.position = Position
