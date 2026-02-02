extends TextureRect

@export var TextureId: StringName = &"missing"

func _ready() -> void:
	texture = NovaTexture.get_texture(TextureId)
	#scale = NovaTexture.get_scale(TextureId, NovaTexture.get_texture_size(TextureId), scale)
	NovaTexture.ReloadTexture.connect(_reload_texture)
	await _nova_ready()


func _nova_ready() -> void:
	pass


func _reload_texture() -> void:
	#scale = NovaTexture.get_scale(TextureId, texture.get_size(), scale)
	texture = NovaTexture.get_texture(TextureId)
