@tool
extends EditorPlugin


func _enable_plugin() -> void:
	var plugin_path: String = "res://addons/nova-resource-packs"
	add_autoload_singleton("NovaTexture", plugin_path + "/globals/NovaTexture.gd")
	add_autoload_singleton("NovaAnimation", plugin_path + "/globals/NovaAnimation.gd")
	add_autoload_singleton("NovaTranslation", plugin_path + "/globals/NovaTranslation.gd")
	add_autoload_singleton("NovaAudio", plugin_path + "/globals/NovaAudio.gd")
	add_autoload_singleton("NovaFont", plugin_path + "/globals/NovaFont.gd")
	add_autoload_singleton("NovaResourcePack", plugin_path + "/globals/NovaResourcePack.gd")


func _disable_plugin() -> void:
	remove_autoload_singleton("NovaTexture")
	remove_autoload_singleton("NovaAnimation")
	remove_autoload_singleton("NovaTranslation")
	remove_autoload_singleton("NovaAudio")
	remove_autoload_singleton("NovaResourcePack")
	remove_autoload_singleton("NovaFont")


func _enter_tree() -> void:
	var plugin_path: String = "res://addons/nova-resource-packs"
	add_custom_type(
		"NovaSprite2D",
		"Sprite2D",
		load(plugin_path + "/nodes/texture/NovaSprite2D.gd"),
		load(plugin_path + "/missing.png")
	)
	add_custom_type(
		"NovaTextureRect",
		"TextureRect",
		load(plugin_path + "/nodes/texture/NovaTextureRect.gd"),
		load(plugin_path + "/missing.png")
	)
	
	add_custom_type(
		"NovaAudioStreamPlayer",
		"AudioStreamPlayer",
		load(plugin_path + "/nodes/audio/NovaAudioStreamPlayer.gd"),
		load(plugin_path + "/missing.png")
	)
	add_custom_type(
		"NovaAudioStreamPlayer2D",
		"AudioStreamPlayer2D",
		load(plugin_path + "/nodes/audio/NovaAudioStreamPlayer2D.gd"),
		load(plugin_path + "/missing.png")
	)
	
	add_custom_type(
		"NovaAnimatedSprite2D",
		"AnimatedSprite2D",
		load(plugin_path + "/nodes/animations/NovaAnimatedSprite2D.gd"),
		load(plugin_path + "/missing.png")
	)


func _exit_tree() -> void:
	remove_custom_type("NovaSprite2D")
	remove_custom_type("NovaTextureRect")
	remove_custom_type("NovaAudioStreamPlayer")
	remove_custom_type("NovaAudioStreamPlayer2D")
	remove_custom_type("NovaAnimatedSprite2D")
