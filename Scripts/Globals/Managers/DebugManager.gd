extends Node

var Debug_mode: bool = false
var Basic_debug: bool = false


func dprint(...args: Array) -> void:
	var output := ""
	for a in args:
		output += str(a)
	print(output)


func reset_variables_to_default() -> void:
	Debug_mode = false
	DebugMan.dprint("[DebugMan, reset_variables_to_default] done")
