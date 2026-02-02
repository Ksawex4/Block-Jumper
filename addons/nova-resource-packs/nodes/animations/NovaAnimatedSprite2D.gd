extends AnimatedSprite2D

@export var AnimationId: StringName = &"missing"
@export var AnimationName: StringName = &"default"
@export var DefaultAnimationName: StringName = &"default"
@export var Autoplay: bool = false
@export var DuplicateSpriteFrames: bool = false
@export var BaseTextureSizeId: StringName = &"missing"
@export var IsBaseTextureSheet: bool = false
@export var BaseTextureSize: Vector2 = Vector2(0, 0)

func _ready() -> void:
	print(BaseTextureSize)
	if BaseTextureSize == Vector2(0, 0):
		BaseTextureSize = NovaTexture.TextureSizes[BaseTextureSizeId]
	print(name)
	sprite_frames = NovaAnimation.get_animation(AnimationId, DuplicateSpriteFrames)
	if IsBaseTextureSheet:
		var frames: Vector2 = Vector2(NovaAnimation.BaseAnimationsData[AnimationId].get("frame-x", 2), NovaAnimation.AnimationsData[AnimationId].get("frame-y", 2))
		BaseTextureSize /= frames
	print(BaseTextureSize)
	NovaAnimation.ReloadAnimation.connect(_reload_animation)
	frame_changed.connect(_update_scale)
	animation_changed.connect(_update_scale)
	
	if Autoplay:
		play(AnimationName)
	await _nova_ready()


func _nova_ready() -> void:
	pass


func _update_scale() -> void:
	var texture: Texture = sprite_frames.get_frame_texture(animation, frame)
	scale = BaseTextureSize / texture.get_size()


func _reload_animation() -> void:
	var will_play: bool = is_playing()
	var animation_name: StringName = animation
	
	sprite_frames = NovaAnimation.get_animation(AnimationId, DuplicateSpriteFrames)
	if will_play:
		play(animation_name)
	_update_scale()
