extends Node2D

@export var SpriteId: StringName = &"bg-1"
@export var force_texture2d: bool = false
@export var ForcedTexture: Texture2D
@export var Mirroring: Vector2i = Vector2i(711, 432)
@export var Motion_scale: Vector2 = Vector2(0.8, 0.8)
@export var Sprite_scale: Vector2 = Vector2(1.0, 1.0)


func _ready() -> void:
	$ParallaxBackground/ParallaxLayer/Sprite2D.change_texture(SpriteId)
	if force_texture2d:
		$ParallaxBackground/ParallaxLayer/Sprite2D.texture = ForcedTexture
	$ParallaxBackground/ParallaxLayer.motion_mirroring = Mirroring
	$ParallaxBackground/ParallaxLayer.motion_scale = Motion_scale * Sprite_scale
	$ParallaxBackground/ParallaxLayer/Sprite2D.scale = Sprite_scale
