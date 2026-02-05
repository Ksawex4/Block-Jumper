extends Button

@export var FontId: StringName = &"main"

func _ready() -> void:
	add_theme_font_override("font", NovaFont.get_font(FontId))
	NovaFont.ReloadFont.connect(_update_font)


func _update_font() -> void:
	add_theme_font_override("font", NovaFont.get_font(FontId))
