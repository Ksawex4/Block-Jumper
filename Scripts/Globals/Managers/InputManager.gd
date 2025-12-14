extends Node

var Saved_controls: Dictionary = {}
var Mobile_jump := false

func get_input_key(action_name: String) -> InputEventKey: 
	var events: Array = InputMap.action_get_events(action_name)
	if events:
		for event: InputEvent in events:
			if event is InputEventKey:
				return event
	return null


func change_keybind(action_name: String, new_key: Key) -> void:
	var events: Array = InputMap.action_get_events(action_name)
	if events:
		for event: InputEvent in events:
			if event is InputEventKey:
				InputMap.action_erase_event(action_name, event)
				var new_event_key: InputEventKey = InputEventKey.new()
				new_event_key.physical_keycode = new_key
				InputMap.action_add_event(action_name, new_event_key)
				Saved_controls.set(action_name, new_key)
				DebugMan.dprint("[InputMan, change_keybind] Changed from ", OS.get_keycode_string(new_event_key.physical_keycode), " for ", action_name)
				break 


func load_keys(keys: Dictionary) -> void:
	if keys != null:
		Saved_controls = keys
		for key in Saved_controls.keys():
			if int(Saved_controls[key]) is Key:
				change_keybind(key, Saved_controls[key])
		DebugMan.dprint("[InputMan, load_keys] Loaded ", keys)


func reset_variables_to_default(reset: bool) -> void:
	if reset:
		Saved_controls = {}
	DebugMan.dprint("[InputMan, reset_variables_to_default] done ", reset)
