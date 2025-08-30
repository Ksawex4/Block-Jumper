extends Window

var waitingForInput := false
var newKey := KEY_0
var whatKeybind := ""
var whosKeybind := ""

func _ready() -> void:
	_update_all_labels()

func _update_all_labels():
	_update_label($FencyUp, "Fency", "up")
	_update_label($FencyLeft, "Fency", "left")
	_update_label($FencyRight, "Fency", "right")
	_update_label($FencyCam, "Fency", "cam")
	_update_label($ToastyUp, "Toasty", "up")
	_update_label($ToastyLeft, "Toasty", "left")
	_update_label($ToastyRight, "Toasty", "right")
	_update_label($ToastyCam, "Toasty", "cam")
	_update_label($PanLoduwkaUp, "PanLoduwka", "up")
	_update_label($PanLoduwkaLeft, "PanLoduwka", "left")
	_update_label($PanLoduwkaRight, "PanLoduwka", "right")
	_update_label($PanLoduwkaCam, "PanLoduwka", "cam")
	

func _update_label(node, player: String, keybind: String) -> void:
	node.text = keybind + ": " + str(OS.get_keycode_string(InputMan.AllPlayerControls[player][keybind]))
 
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and waitingForInput:
		newKey = event.keycode
		waitingForInput = false
		InputMan.ChangePlayerKeybind(whosKeybind, whatKeybind, newKey)
		SignalMan.emit_signal("UpdateControls")
		_update_all_labels()

func _on_close_requested() -> void:
	hide()

func _on_fency_up_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "up"
	waitingForInput = true

func _on_fency_left_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "left"
	waitingForInput = true

func _on_fency_right_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "right"
	waitingForInput = true

func _on_fency_cam_pressed() -> void:
	whosKeybind = "Fency"
	whatKeybind = "cam"
	waitingForInput = true

func _on_toasty_up_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "up"
	waitingForInput = true

func _on_toasty_left_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "left"
	waitingForInput = true

func _on_toasty_right_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "right"
	waitingForInput = true

func _on_toasty_cam_pressed() -> void:
	whosKeybind = "Toasty"
	whatKeybind = "cam"
	waitingForInput = true

func _on_pan_loduwka_up_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "up"
	waitingForInput = true

func _on_pan_loduwka_left_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "left"
	waitingForInput = true

func _on_pan_loduwka_right_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "right"
	waitingForInput = true

func _on_pan_loduwka_cam_pressed() -> void:
	whosKeybind = "PanLoduwka"
	whatKeybind = "cam"
	waitingForInput = true
