extends Node2D

@export var sprite: String = "res://Assets/Sprites/Backgrounds/Background1.png"
@export var spriteSize: Vector2i = Vector2i(711, 432)
@export var spriteScale: Vector2 = Vector2(0.8, 0.8)

func _ready() -> void:
	$ParallaxBackground/ParallaxLayer/Sprite2D.texture = load(sprite)
	$ParallaxBackground/ParallaxLayer.motion_mirroring = spriteSize
	$ParallaxBackground/ParallaxLayer.motion_scale = spriteScale
	print("[background.gd] set the background to '", sprite, "'")
