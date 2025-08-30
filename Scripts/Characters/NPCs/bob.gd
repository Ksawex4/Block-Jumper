extends CharacterBody2D

var players: Array
var canGlitch: bool
var canMoveThings: bool
var canAddVelocity: bool
var canSpawnBouncy: bool
@export var chillGuy := false

func _ready() -> void:
	players = get_tree().get_nodes_in_group("players")
	if BobMan.SavedBobs == 8 and !chillGuy:
		var bouncy = load("res://Scenes/Characters/NPCs/bouncy_onurb.tscn")
		var instance = bouncy.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = position

func _physics_process(_delta: float) -> void:
	if !chillGuy:
		if players:
			var player = players.pick_random()
			if player:
				var playerx = player.position.x
				var playery = player.position.y 
				position.x = randi_range(playerx-100, playerx+100)
				position.y = randi_range(playery-100, playery+100)
		else:
			players = get_tree().get_nodes_in_group("players")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !chillGuy:
		if canAddVelocity:
			if body.get("velocity") != null:
				body.velocity += Vector2(randf_range(-100,100), randf_range(-100,100))
		
		if canSpawnBouncy:
			if randi_range(1,500) == 48:
				var bouncy = load("res://Scenes/Characters/NPCs/bouncy_onurb.tscn")
				var instance = bouncy.instantiate()
				get_tree().current_scene.call_deferred("add_child", instance)
				instance.position = position
		
		if randi_range(1,100) == 37:
			if canMoveThings != null and canMoveThings:
				body.position += Vector2(randi_range(-1,1),randi_range(-1,1))
				body.rotation += randf_range(-0.1,0.1)
			
			if canGlitch != null and canGlitch == true:
				if body.has_node("Sprite2D") or body.has_node("AnimatedSprite2D") or body is TileMapLayer:
					var sprit
					if body.has_node("Sprite2D"):
						sprit = body.get_node("Sprite2D")
					elif body.has_node("AnimatedSprite2D"):
						sprit = body.get_node("AnimatedSprite2D")
					if sprit != null:
						var glitchMaterial = ShaderMaterial.new()
						glitchMaterial.shader = load("res://Assets/Shaders/Glitched.gdshader")
						sprit.material = glitchMaterial
					elif body is TileMapLayer:
						var mapPos = body.local_to_map(global_position)
						if body.get_cell_atlas_coords(Vector2i(mapPos.x, mapPos.y)) != Vector2i(-1, -1) and body.get_cell_atlas_coords(Vector2i(mapPos.x, mapPos.y)) != Vector2i(4, 1):
							body.set_cell(Vector2i(mapPos.x, mapPos.y), 0, Vector2i(3,1))
			else:
				await get_tree().create_timer(0.2).timeout
				canGlitch = BobMan.CanBobsGlitch
				canMoveThings = BobMan.CanBobsMoveThings
				canAddVelocity = BobMan.CanBobsAddVelocity
				canSpawnBouncy = BobMan.CanSpawnBouncy_onurB
