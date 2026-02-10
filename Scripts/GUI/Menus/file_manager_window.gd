extends Window


func _ready() -> void:
	if has_theme_font_override("title_font"):
		remove_theme_font_override("title_font")
	add_theme_font_override("title_font", NovaFont.get_font(&"main"))
	NovaFont.ReloadFont.connect(_update_font)


func _update_font() -> void:
	if has_theme_font_override("title_font"):
		remove_theme_font_override("title_font")
	add_theme_font_override("title_font", NovaFont.get_font(&"main"))


func _on_close_requested() -> void:
	hide()
