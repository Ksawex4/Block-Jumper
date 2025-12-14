extends Node2D

@export var Sprite: Resource = preload("uid://d17ambl7737n3")
@export var Mirroring: Vector2i = Vector2i(711, 432)
@export var Motion_scale: Vector2 = Vector2(0.8, 0.8)
@export var Sprite_scale: Vector2 = Vector2(1.0, 1.0)


func _ready() -> void:
	$ParallaxBackground/ParallaxLayer/Sprite2D.texture = Sprite
	$ParallaxBackground/ParallaxLayer.motion_mirroring = Mirroring
	$ParallaxBackground/ParallaxLayer.motion_scale = Motion_scale * Sprite_scale
	$ParallaxBackground/ParallaxLayer/Sprite2D.scale = Sprite_scale
