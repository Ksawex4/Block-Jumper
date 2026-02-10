extends RichTextLabel

@export var FontId: StringName = &"main"

func _ready() -> void:
	if has_theme_font_override("normal_font"):
		remove_theme_font_override("normal_font")
	add_theme_font_override("normal_font", NovaFont.get_font(FontId))
	


func _update_font() -> void:
	if has_theme_font_override("normal_font"):
		remove_theme_font_override("normal_font")
	add_theme_font_override("normal_font", NovaFont.get_font(FontId))
