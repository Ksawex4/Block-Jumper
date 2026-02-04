extends Sprite2D

@export var TextureId: StringName = &"missing"

func _ready() -> void:
	texture = NovaTexture.get_texture(TextureId)
	scale = NovaTexture.get_scale(TextureId, NovaTexture.get_texture_size(TextureId), scale)
	NovaTexture.ReloadTexture.connect(_reload_texture)
	await _nova_ready()


func _nova_ready() -> void:
	pass


func _reload_texture() -> void:
	scale = NovaTexture.get_scale(TextureId, texture.get_size(), scale)
	texture = NovaTexture.get_texture(TextureId)


func change_texture(new_texture_id: StringName, base_scale: Vector2 = Vector2(1.0, 1.0)):
	TextureId = new_texture_id
	texture = NovaTexture.get_texture(TextureId)
	scale = NovaTexture.get_scale(TextureId, NovaTexture.get_texture_size(TextureId), base_scale)
