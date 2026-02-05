extends RichTextLabel

@export var FontId: StringName = &"main"

func _ready() -> void:
	add_theme_font_override("normal_font", NovaFont.get_font(FontId))
