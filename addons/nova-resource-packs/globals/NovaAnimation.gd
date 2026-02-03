extends Node

var Animations: Dictionary[StringName, SpriteFrames]
var BaseAnimationsData: Dictionary[StringName, Dictionary]
var AnimationsData: Dictionary[StringName, Dictionary] # CurrentData
signal ReloadAnimation()


func add_animation(id: StringName, animation_data: Dictionary) -> void:
	var type: String = animation_data.get("type")
	
	match type:
		"sheet":
			_add_animation_sheet(id, animation_data)
		"frames":
			_add_animation_frames(id, animation_data)
		_:
			push_warning("Wrong animation type for %s, type: %s" % [id, type])


func _add_animation_sheet(id: StringName, animation_data: Dictionary) -> void:
	var fps: float = animation_data.get("fps", 5.0)
	var loop: bool = animation_data.get("loop", false)
	var texture_id: StringName = animation_data.get("texture-id", &"missing")
	var remove_x_frames: int = animation_data.get("remove-x-frames", 0)
	var frames: Vector2 = Vector2(
		animation_data.get("frames-x", 2),
		animation_data.get("frames-y", 2)
	)
	var new_id: StringName = id.split(".")[0]
	var animation_name: StringName = &"default"
	if id.split(".").size() > 1:
		animation_name = id.split(".")[1]
	
	var sprite_frames: SpriteFrames = Animations.get(new_id, SpriteFrames.new())
	
	if sprite_frames.has_animation(animation_name):
		sprite_frames.remove_animation(animation_name)
	
	sprite_frames.add_animation(animation_name)
	sprite_frames.set_animation_loop(animation_name, loop)
	sprite_frames.set_animation_speed(animation_name, fps)
	
	var atlas: AtlasTexture = AtlasTexture.new()
	var texture: Texture2D = NovaTexture.get_texture(texture_id)
	atlas.atlas = texture
	var region: Rect2 = Rect2(Vector2(0.0, 0.0), texture.get_size())
	region.size = texture.get_size() / frames
	atlas.region = region
	for y in range(frames.y):
		for x in range(frames.x):
			sprite_frames.add_frame(animation_name, ImageTexture.create_from_image(atlas.get_image()))
			atlas.region.position.x += region.size.x
		atlas.region.position.x = 0.0
		atlas.region.position.y += region.size.y
	
	if sprite_frames.get_frame_count(animation_name) <= remove_x_frames:
		remove_x_frames = sprite_frames.get_frame_count(animation_name) - 1
	
	for x in range(remove_x_frames):
		sprite_frames.remove_frame(animation_name, sprite_frames.get_frame_count(animation_name) - 1)
	
	Animations.set(new_id, sprite_frames)
	if !BaseAnimationsData.has(id):
		BaseAnimationsData.set(id, animation_data)
	AnimationsData.set(id, animation_data)


func _add_animation_frames(id: StringName, animation_data: Dictionary) -> void:
	var fps: float = animation_data.get("fps", 5.0)
	var loop: bool = animation_data.get("loop", false)
	var texture_ids: Array = animation_data.get("texture-id", [&"missing"])
	
	var new_id: StringName = id.split(".")[0]
	var animation_name: StringName = &"default"
	if id.split(".").size() > 1:
		animation_name = id.split(".")[1]
	
	var sprite_frames: SpriteFrames = Animations.get(new_id, SpriteFrames.new())
	
	if sprite_frames.has_animation(animation_name):
		sprite_frames.remove_animation(animation_name)
	
	sprite_frames.add_animation(animation_name)
	sprite_frames.set_animation_loop(animation_name, loop)
	sprite_frames.set_animation_speed(animation_name, fps)
	
	for texture_id: StringName in texture_ids:
		var texture: Texture2D = NovaTexture.get_texture(texture_id)
		sprite_frames.add_frame(animation_name, texture)
	
	Animations.set(new_id, sprite_frames)
	if !BaseAnimationsData.has(id):
		BaseAnimationsData.set(id, animation_data)
	AnimationsData.set(id, animation_data)


func get_animation(id: StringName, duplicate: bool = false) -> SpriteFrames:
	if Animations.has(id):
		return Animations[id]
	push_warning("Animation with id: %s doesn't exist, returning empty SpriteFrames" % id)
	return SpriteFrames.new()


func get_animation_texture_size(id: StringName) -> Vector2:
	if !AnimationsData.has(id):
		push_warning("Animation with %s doesn't exist, returning 'missing' size" % id)
		return NovaTexture.get_texture_size(&"missing")
	
	var animation_data: Dictionary = AnimationsData[id]
	var texture_id: StringName = &"missing"
	var type: String = animation_data.get("type")
	match type:
		"sheet":
			texture_id = animation_data.get("texture_id", &"missing")
		"frames":
			texture_id = animation_data.get("texture_id", [&"missing"])[0]
	
	var texture_size: Vector2 = NovaTexture.get_texture_size(texture_id)
	if type == "sheet":
		texture_size /= Vector2(animation_data.get("frames-x", 2), animation_data.get("frames-y", 2))
	
	return texture_size


func load_animations_data(animations_data: Dictionary) -> void:
	print("Loading animations")
	for animation_id: StringName in animations_data.keys():
		add_animation(animation_id, animations_data[animation_id])


func load_base_animations(data: Dictionary = {}) -> void:
	Animations = {}
	AnimationsData = {}
	if data.is_empty():
		data = NovaResourcePack.get_pack_data()
	
	if data.is_empty():
		push_warning("Base pack data is empty!")
		return
	
	var animations_data: Dictionary = data.get("animations", {})
	load_animations_data(animations_data)
