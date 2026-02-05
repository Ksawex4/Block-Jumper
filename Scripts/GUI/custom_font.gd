extends Label

@export var FontId: StringName = &"main"

func _ready() -> void:
	if !label_settings:
		label_settings = LabelSettings.new()
	
	label_settings.font = NovaFont.get_font(FontId)
