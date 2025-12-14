extends CharacterBody2D

enum BobertIdk {
	CHILL,
	QUIET,
}
enum WhichSprite {
	NORMAL,
	CORRUPTED,
}
@export var Bobert_idk_too: Array[BobertIdk]
@export var Sprite: WhichSprite
@export var Spin: bool = false
var Bouncy_onurb := preload("uid://b83uowllfiji")
var Players: Array
var Glitch: bool
var Spin_things: bool
var Add_velocity: bool
var Spawn_bouncy: bool
var Scale: bool
var Spin_speed: float = randf_range(0.01,0.1) * 60.0
@onready var AreaColl := $Area2D/CollisionShape2D


func _ready() -> void:
	match Sprite:
		WhichSprite.NORMAL: $Sprite2D.texture = preload("uid://b6wt7a2ttj22b")
		WhichSprite.CORRUPTED: $Sprite2D.texture = preload("uid://idv0qkopgg6")
	Glitch = BobMan.Can_glitch
	Spin_things = BobMan.Can_spin
	Add_velocity = BobMan.Can_add_velocity
	Spawn_bouncy = BobMan.Can_spawn_bouncy
	Scale = BobMan.Can_scale


func _physics_process(delta: float) -> void:
	if Spin:
		global_rotation += Spin_speed * delta
	
	if BobertIdk.CHILL not in Bobert_idk_too:
		if Players:
			var player = Players.pick_random()
			if player:
				position.x = randf_range(player.position.x-100, player.position.x+100)
				position.y = randf_range(player.position.y -100, player.position.y +100)
			else:
				Players = get_tree().get_nodes_in_group("players")
		else:
			Players = get_tree().get_nodes_in_group("players")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if BobertIdk.CHILL not in Bobert_idk_too:
		if Add_velocity and body.get("velocity") != null:
			body.velocity += Vector2(randf_range(-100,100), randf_range(-100,100))
		
		if Spawn_bouncy and randi_range(1,250) == 48:
			var instance: Node2D = Bouncy_onurb.instantiate()
			get_tree().current_scene.call_deferred("add_child", instance)
			instance.position = position
		
		if randi_range(1,100) == 37:
				if Spin_things:
					body.rotation += randf_range(-0.1,0.1)
				
				if Scale:
					body.scale = Vector2(randf_range(0.5, 5), randf_range(0.5, 5))
				
				if Glitch:
					if body.has_node("Sprite2D") or body.has_node("AnimatedSprite2D") or body is TileMapLayer:
						var sprit: Node2D
						if body.has_node("Sprite2D"):
							sprit = body.get_node("Sprite2D")
						elif body.has_node("AnimatedSprite2D"):
							sprit = body.get_node("AnimatedSprite2D")
						
						if sprit:
							var glitchMaterial: ShaderMaterial = ShaderMaterial.new()
							glitchMaterial.shader = preload("uid://fq4lex2ehio0")
							sprit.material = glitchMaterial
						elif body is TileMapLayer:
							var mapPos: Vector2i = body.local_to_map(global_position)
							if body.get_cell_atlas_coords(Vector2i(mapPos.x, mapPos.y)) != Vector2i(-1, -1) and body.get_cell_atlas_coords(Vector2i(mapPos.x, mapPos.y)) != Vector2i(4, 1):
								body.set_cell(Vector2i(mapPos.x, mapPos.y), 0, Vector2i(3,1))
