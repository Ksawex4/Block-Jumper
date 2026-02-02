extends Node


var Textures: Dictionary[StringName, Texture2D] = {
	&"missing": load("res://addons/nova-resource-packs/missing.png")
}
var TextureSizes: Dictionary[StringName, Vector2] = {
	&"missing": Textures[&"missing"].get_size()
}
signal ReloadTexture()


func add_texture(id: StringName, texture: Texture2D) -> void:
	if texture != null:
		if !TextureSizes.has(id):
			TextureSizes.set(id, texture.get_size())
		Textures.set(id, texture)
	else:
		Textures.set(id, Textures[&"missing"])


func get_texture(id: StringName) -> Texture2D:
	if Textures.has(id):
		return Textures[id]
	push_warning("Texture with id: %s doesn't exist, returning 'missing' texture" % id)
	return Textures[&"missing"]


## old_size is the Texture size, scale is transform scale
func get_scale(id: StringName, old_size: Vector2, scale: Vector2) -> Vector2:
	var texture_size: Vector2 = get_texture(id).get_size()
	if texture_size == old_size:
		return scale
	var new_scale = old_size/texture_size * scale
	
	return new_scale


func get_texture_size(id: StringName) -> Vector2:
	if Textures.has(id):
		return TextureSizes.get(id, TextureSizes[&"missing"])
	push_warning("Texture with id: %s doesn't exist, returning 'missing' texture" % id)
	return TextureSizes[&"missing"]


func get_texture_from_file(texture_path: String) -> Texture2D:
	var exists: bool = (
		(FileAccess.file_exists(texture_path) and texture_path.begins_with("user://"))
		or (ResourceLoader.exists(texture_path)) and texture_path.begins_with("res://"))
	if !exists:
		push_warning("File doesnt exist at path: %s" % texture_path)
	if texture_path.begins_with("res://") and exists:
		return load(texture_path)
	elif texture_path.begins_with("user://") and exists:
		var image: Image = Image.new()
		var err = image.load(texture_path)
		
		if image != null and err == OK:
			var texture: ImageTexture = ImageTexture.create_from_image(image)
			if texture != null:
				return texture
		else:
			print("%s err: %s" % [texture_path, err])
	
	print("Failed to load, loading as 'missing' texture_path: %s" % texture_path)
	return Textures[&"missing"]


func load_base_textures(data: Dictionary = {}) -> void:
	Textures = {
		&"missing": load("res://addons/nova-resource-packs/missing.png")
	}
	if data.is_empty():
		data = NovaResourcePack.get_pack_data()
	
	if data.is_empty():
		push_warning("Base pack data is empty!")
		return
	
	var assets_path: String = data.get("assets-path", "")
	if assets_path.is_empty():
		push_warning("Base pack 'assets-path' is empty. Its recommended to add one for the base pack than typing every full path")
	var textures_path: String = assets_path + data.get("textures-path", "")
	var textures: Dictionary = data.get("textures", {})
	
	print("Loading texture pack: %s" % NovaResourcePack.BASE_PACK_ID)
	load_textures(textures, textures_path)


func load_textures(textures: Dictionary, textures_path: String) -> void:
	print("Loading textures")
	for texture_id: StringName in textures.keys():
		var texture_path: String = textures_path + textures[texture_id]
		var texture: Texture2D = get_texture_from_file(texture_path)
		add_texture(texture_id, texture)
