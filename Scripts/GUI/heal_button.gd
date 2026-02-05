extends Button

@onready var Parent = $".."
@export var FontId: StringName = &"main"

func _ready() -> void:
	add_theme_font_override("font", NovaFont.get_font(FontId))
	NovaFont.ReloadFont.connect(_update_font)


func _update_font() -> void:
	add_theme_font_override("font", NovaFont.get_font(&"main"))


func _on_pressed() -> void:
	Parent.heal_player(name)
