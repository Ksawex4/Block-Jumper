extends Node

var Paused: bool = false
#var AllPlayerControls = {
	#"Fency": {"left": KEY_A, "right": KEY_D, "up": KEY_W, "down": KEY_S, "cam": KEY_1},
	#"Toasty": {"left": KEY_J, "right": KEY_L, "up": KEY_I, "down": KEY_K, "cam": KEY_3},
	#"PanLoduwka": {"left": KEY_F, "right": KEY_H, "up": KEY_T, "down": KEY_G, "cam": KEY_2}
#}

func _ready() -> void:
	SignalMan.connect("Continue", Callable(self, "_on_continue"))
	print("[InputManager.gd] Loaded")

func GetKeyAxis(negKey: int, posKey: int) -> float:
	var axis: float = 0.0
	if Input.is_key_pressed(negKey):
		axis -= 1.0
	if Input.is_key_pressed(posKey):
		axis += 1.0
	return axis

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Pause") and not get_tree().get_nodes_in_group("pauseMenu").is_empty():
		get_tree().paused = true
		SignalMan.emit_signal("Pause")

func _on_continue() -> void:
	get_tree().paused = false

func ResetVariablesToDefault() -> void:
	Paused = false
	print("[InputManager.gd] Reseted variables")

func ChangeKeybind(actionName: String, newKey: Key) -> void:
	var events: Array = InputMap.action_get_events(actionName)
	if events:
		for event: InputEvent in events:
			if event is InputEventKey:
				InputMap.action_erase_event(actionName, event)
				var newEventKey: InputEventKey = InputEventKey.new()
				newEventKey.physical_keycode = newKey
				InputMap.action_add_event(actionName, newEventKey)
				break 

func GetInputKey(actionName: String) -> InputEventKey: 
	var events: Array = InputMap.action_get_events(actionName)
	if events:
		for event: InputEvent in events:
			if event is InputEventKey:
				return event
	return null
