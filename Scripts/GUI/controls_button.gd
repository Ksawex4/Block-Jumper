extends Button

@onready var Parent := $".."
@export var FontId: StringName = &"main"

func _ready() -> void:
	add_theme_font_override("font", NovaFont.get_font(FontId))
	NovaFont.ReloadFont.connect(_update_font)
	Parent.connect("UpdateLabel", Callable(self, "_update_label"))


func _update_font() -> void:
	add_theme_font_override("font", NovaFont.get_font(FontId))


func _on_pressed() -> void:
	Parent.Keybind = name
	Parent.Waiting_for_input = true


func _update_label() -> void:
	var key := InputMan.get_input_key(name)
	text = name + ": " + str(OS.get_keycode_string(key.physical_keycode if key != null else KEY_I))
