extends Button

@export var file_path: String = "user://nonexistent.bj"
@onready var Parent: Control = $".."
@export var Make_parent_invis := true
@export var FontId: StringName = &"main"

func _ready() -> void:
	add_theme_font_override("normal_font", NovaFont.get_font(FontId))
	if Make_parent_invis and FileAccess.file_exists(file_path):
		Parent.show()


func _on_pressed() -> void:
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
		DebugMan.dprint("[file_remover_button, on_pressed] Removed file %s" % file_path)
	else:
		print(file_path)
	
	if Make_parent_invis and Parent:
		Parent.hide()
	else:
		print(Parent != null)
	
