extends Window

var waitingForInput: bool = false
var newKey: Key = KEY_0
var keybind: String = ""

func _ready() -> void:
	_update_all_labels()

func _update_all_labels() -> void:
	_update_label($FencyUp, "FencyJump", "Jump")
	_update_label($FencyLeft, "FencyLeft", "Left")
	_update_label($FencyRight, "FencyRight", "Right")
	_update_label($FencyCam, "FencyCam", "Cam")
	_update_label($ToastyJump, "ToastyJump", "Jump")
	_update_label($ToastyLeft, "ToastyLeft", "Left")
	_update_label($ToastyRight, "ToastyRight", "Right")
	_update_label($ToastyCam, "ToastyCam", "Cam")
	_update_label($PanLoduwkaJump, "PanLoduwkaJump", "Jump")
	_update_label($PanLoduwkaLeft, "PanLoduwkaLeft", "Left")
	_update_label($PanLoduwkaRight, "PanLoduwkaRight", "Right")
	_update_label($PanLoduwkaCam, "PanLoduwkaCam", "Cam")
	print("[controls_menu.gd] Updated all control labels")

func _update_label(node: Button, actionName: String, _keybind: String) -> void:
	node.text = _keybind + ": " + str(OS.get_keycode_string(InputMan.GetInputKey(actionName).physical_keycode))
 
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and waitingForInput:
		print("[controls_menu.gd] Changed keybind '", keybind, "' to '", event.keycode, "'")
		newKey = event.keycode
		waitingForInput = false
		InputMan.ChangeKeybind(keybind, newKey)
		_update_all_labels()

func _on_close_requested() -> void:
	hide()
