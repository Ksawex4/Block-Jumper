extends Area2D
## Without .tscn extension
@export var Level_name: String = "boot_screen"
## If true, changes level to Level_name, if false, teleports the player
@export var Change_level: bool = true
## Position of where to teleport the player
@export var Position: Vector2 = Vector2(0,0)
## Which player can interract with this
@export var Which_players := ["Fency", "PanLoduwka", "Toasty"]
## if it should show the info of what players can enter this area2d
@export var Show_info := false

func _ready() -> void:
	if len(Which_players) != 3 and Show_info:
		$Label.show()
		$Label.text = "Can Only teleport:\n"
		for x in Which_players:
			$Label.text += x + " "

func _on_body_entered(body: Node2D) -> void:
	if body.WhoAmI in Which_players:
		if Change_level:
			LevelMan.change_level(Level_name + ".tscn")
		else:
			body.position = Position
