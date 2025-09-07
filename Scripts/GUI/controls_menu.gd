extends Window

var waitingForInput: bool = false
var newKey: Key = KEY_0
var whatKeybind: String = ""
var whosKeybind: String = ""

func _ready() -> void:
	_update_all_labels()

func _update_all_labels() -> void:
	_update_label($FencyUp, "FencyJump", "Jump")
	_update_label($FencyLeft, "FencyLeft", "Left")
	_update_label($FencyRight, "FencyRight", "Right")
	_update_label($FencyCam, "FencyCam", "Cam")
	_update_label($ToastyUp, "ToastyJump", "Jump")
	_update_label($ToastyLeft, "ToastyLeft", "Left")
	_update_label($ToastyRight, "ToastyRight", "Right")
	_update_label($ToastyCam, "ToastyCam", "Cam")
	_update_label($PanLoduwkaUp, "PanLoduwkaJump", "Jump")
	_update_label($PanLoduwkaLeft, "PanLoduwkaLeft", "Left")
	_update_label($PanLoduwkaRight, "PanLoduwkaRight", "Right")
	_update_label($PanLoduwkaCam, "PanLoduwkaCam", "Cam")
	print("[controls_menu.gd] Updated all control labels")

func _update_label(node: Node2D, actionName: String, keybind: String) -> void:
	node.text = keybind + ": " + str(OS.get_keycode_string(InputMan.GetInputKey(actionName).physical_keycode))
 
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and waitingForInput:
		print("[controls_menu.gd] Changed keybind '", whosKeybind + whatKeybind, "' to '", event.keycode, "'")
		newKey = event.keycode
		waitingForInput = false
		InputMan.ChangeKeybind(whosKeybind + whatKeybind, newKey)
		_update_all_labels()

func _on_close_requested() -> void:
	hide()

func _on_fency_up_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "Jump"
	waitingForInput = true

func _on_fency_left_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "Left"
	waitingForInput = true

func _on_fency_right_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "Right"
	waitingForInput = true

func _on_fency_cam_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "Cam"
	waitingForInput = true

func _on_toasty_up_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "Jump"
	waitingForInput = true

func _on_toasty_left_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "Left"
	waitingForInput = true

func _on_toasty_right_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "Right"
	waitingForInput = true

func _on_toasty_cam_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "Cam"
	waitingForInput = true

func _on_pan_loduwka_up_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "Jump"
	waitingForInput = true

func _on_pan_loduwka_left_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "Left"
	waitingForInput = true

func _on_pan_loduwka_right_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "Right"
	waitingForInput = true

func _on_pan_loduwka_cam_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "Cam"
	waitingForInput = true
