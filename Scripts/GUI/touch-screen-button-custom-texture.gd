extends TouchScreenButton

@export var TextureId: StringName = &"missing"

func _ready() -> void:
	texture_normal = NovaTexture.get_texture(TextureId)
	scale = NovaTexture.get_scale(TextureId, NovaTexture.get_texture_size(TextureId), scale)
	NovaTexture.ReloadTexture.connect(_reload_texture)


func _reload_texture() -> void:
	scale = NovaTexture.get_scale(TextureId, texture_normal.get_size(), scale)
	texture_normal = NovaTexture.get_texture(TextureId)


func change_texture(new_texture_id: StringName, base_scale: Vector2 = Vector2(1.0, 1.0)):
	TextureId = new_texture_id
	texture_normal = NovaTexture.get_texture(TextureId)
	scale = NovaTexture.get_scale(TextureId, NovaTexture.get_texture_size(TextureId), base_scale)
