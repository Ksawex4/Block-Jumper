extends CharacterBody2D

var players: Array
var canGlitch: bool
var canMoveThings: bool
var canAddVelocity: bool
var canSpawnBouncy: bool
var canScale: bool
@export var chillGuy: bool = false
@export var isQuiet: bool = false
@export var whichTexture: String = "Bob"
@export var spin: bool = false
var spinSpeed: float = randf_range(0.01,0.1)
var bouncy_onurb := preload("uid://b83uowllfiji")

func _ready() -> void:
	players = get_tree().get_nodes_in_group("players")
	if BobMan.SavedBobs == 8 and !chillGuy:
		var instance: Node2D = bouncy_onurb.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.position = position
	if !isQuiet:
		$AudioStreamPlayer.autoplay = true
		$AudioStreamPlayer.play()
	
	var texture: Resource = load("res://Assets/Sprites/Characters/NPCs/BOBER.png".replace("BOBER", whichTexture))
	if texture:
		$Sprite2D.texture = load("res://Assets/Sprites/Characters/NPCs/BOBER.png".replace("BOBER", whichTexture))

func _physics_process(_delta: float) -> void:
	if spin:
		global_rotation += spinSpeed
	if !chillGuy:
		if players:
			var player = players.pick_random()
			if player:
				var playerx: float = player.position.x
				var playery: float = player.position.y 
				position.x = randf_range(playerx-100, playerx+100)
				position.y = randf_range(playery-100, playery+100)
		else:
			players = get_tree().get_nodes_in_group("players")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !chillGuy:
		if canAddVelocity:
			if body.get("velocity") != null:
				body.velocity += Vector2(randf_range(-100,100), randf_range(-100,100))
		
		if canSpawnBouncy:
			if randi_range(1,500) == 48:
				var instance: Node2D = bouncy_onurb.instantiate()
				get_tree().current_scene.call_deferred("add_child", instance)
				instance.position = position
		
		if randi_range(1,100) == 37:
			if canMoveThings != null and canMoveThings:
				body.position += Vector2(randi_range(-5,5),randi_range(-5,5))
				body.rotation += randf_range(-0.1,0.1)
			
			if canScale != null and canScale:
				body.scale = Vector2(randf_range(0.5, 5), randf_range(0.5, 5))
			
			if canGlitch != null and canGlitch == true:
				if body.has_node("Sprite2D") or body.has_node("AnimatedSprite2D") or body is TileMapLayer:
					var sprit: Node2D
					if body.has_node("Sprite2D"):
						sprit = body.get_node("Sprite2D")
					elif body.has_node("AnimatedSprite2D"):
						sprit = body.get_node("AnimatedSprite2D")
					if sprit != null:
						var glitchMaterial: ShaderMaterial = ShaderMaterial.new()
						glitchMaterial.shader = load("res://Assets/Shaders/Glitched.gdshader")
						sprit.material = glitchMaterial
					elif body is TileMapLayer:
						var mapPos: Vector2i = body.local_to_map(global_position)
						if body.get_cell_atlas_coords(Vector2i(mapPos.x, mapPos.y)) != Vector2i(-1, -1) and body.get_cell_atlas_coords(Vector2i(mapPos.x, mapPos.y)) != Vector2i(4, 1):
							body.set_cell(Vector2i(mapPos.x, mapPos.y), 0, Vector2i(3,1))
			else:
				await get_tree().create_timer(0.2).timeout
				canGlitch = BobMan.CanBobsGlitch
				canMoveThings = BobMan.CanBobsMoveThings
				canAddVelocity = BobMan.CanBobsAddVelocity
				canSpawnBouncy = BobMan.CanSpawnBouncy_onurB
				canScale = BobMan.CanBobsScale
