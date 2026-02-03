extends AnimatedSprite2D

## AnimationId from your base data.json [code]"animations"[/code] part[br]
## its the [code]AnimationId[/code].AnimationName part of the id, if its without [code].[/code] then its just the id
@export var AnimationId: StringName = &"missing"
## AnimationName from your base data.json [code]"animations"[/code] part[br]
## its the AnimationId.[code]AnimationName[/code] part of the id, it its without [code].[/code] then its [code]&"default"[/code]
@export var AnimationName: StringName = &"default"
## if the animation will play when its ready in the scene
@export var Autoplay: bool = false
## if it should duplicate the animation from NovaAnimation.Animations instead of reusing[br]
## it's needed to edit the sprite_frames without breaking other nodes that use this animation
@export var DuplicateSpriteFrames: bool = false
## base size of a single frame in your animation, all frames will be scaled to this size
@export var BaseFrameSize: Vector2 = Vector2(64, 64)
## use this instead of scale when editing the scale in-game, beacuse if you use [code]scale[/code] it will get overwritten
@export var NovaScale: Vector2 = Vector2(1.0, 1.0)

## use _nova_ready() unless you want to edit how the animation is loaded
func _ready() -> void:
	sprite_frames = NovaAnimation.get_animation(AnimationId, DuplicateSpriteFrames)
	
	NovaAnimation.ReloadAnimation.connect(_reload_animation)
	frame_changed.connect(_update_scale)
	animation_changed.connect(_update_scale)
	
	if Autoplay:
		play(AnimationName)
	_update_scale()
	await _nova_ready()


func _nova_ready() -> void:
	pass


func _update_scale() -> void:
	var texture: Texture = sprite_frames.get_frame_texture(animation, frame)
	scale = BaseFrameSize / texture.get_size() * NovaScale


func _reload_animation() -> void:
	var will_play: bool = is_playing()
	var animation_name: StringName = animation
	
	sprite_frames = NovaAnimation.get_animation(AnimationId, DuplicateSpriteFrames)
	_update_scale()
	if will_play:
		play(animation_name)
