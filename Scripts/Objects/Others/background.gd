extends Node2D

@export var sprite = "res://Assets/Sprites/Backgrounds/Background1.png"
@export var spriteSize = Vector2i(711, 432)
@export var spriteScale = Vector2(0.8, 0.8)

func _ready() -> void:
	$ParallaxBackground/ParallaxLayer/Sprite2D.texture = load(sprite)
	$ParallaxBackground/ParallaxLayer.motion_mirroring = spriteSize
	$ParallaxBackground/ParallaxLayer.motion_scale = spriteScale
	
