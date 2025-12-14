extends Window

var Waiting_for_input: bool = false
var New_key: Key = KEY_0
var Keybind: String = ""
signal UpdateLabel()

func _ready() -> void:
	emit_signal("UpdateLabel")


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and Waiting_for_input:
		DebugMan.dprint("[controls_menu, _input] Changed  ", Keybind, " to ", OS.get_keycode_string(event.keycode))
		New_key = event.keycode
		Waiting_for_input = false
		InputMan.change_keybind(Keybind, New_key)
		emit_signal("UpdateLabel")


func _on_close_requested() -> void:
	hide()
