extends Label

@export var FontId: StringName = &"main"

func _ready() -> void:
	_update_font()
	NovaFont.ReloadFont.connect(_update_font)


func _update_font() -> void:
	if !label_settings:
		label_settings = LabelSettings.new()
	
	label_settings.font = NovaFont.get_font(FontId)
