extends Node

var Game_version: Variant = ProjectSettings.get_setting("application/config/version")


func save_file(file_name: String, data: Dictionary, encode: bool =true, path: String ="user://") -> void:
	var data_string: String = stringify_and_encode(data) if encode else JSON.stringify(data)
	var file_path := path + file_name
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	if FileAccess.get_open_error() == OK:
		file.store_string(data_string)
		file.close()
		DebugMan.dprint("[SaveMan, save_file] Saved file ", file_path, " ", data)
	else:
		push_error("Failed to create file at ", file_path, " got error: ", FileAccess.get_open_error())


## Reads the encoded (or not) file and then return it as a Dictionary
## an empty Dictionary means File doesn't exist, some error appeared or the file had an empty dictionary
func get_data_from_file(file_name: String, encoded: bool=true, path: String="user://") -> Dictionary:
	var file_path := path + file_name
	if FileAccess.file_exists(file_path):
		var file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		if FileAccess.get_open_error() == OK:
			var data_string: String = file.get_as_text()
			var data: Dictionary = decode_and_parse(data_string) if encoded else JSON.parse_string(data_string)
			DebugMan.dprint("[SaveMan, save_file] Got data from file ", file_path, " ", data)
			return data
		else:
			push_error("Failed to read file at ", file_path, " got error: ", FileAccess.get_open_error())
			return {}
	else:
		return {}


func stringify_and_encode(data: Dictionary) -> String:
	var json_string = JSON.stringify(data)
	return Marshalls.utf8_to_base64(json_string)


func decode_and_parse(encoded_string: String) -> Dictionary:
	var decoded: String = Marshalls.base64_to_utf8(encoded_string)
	var data = JSON.parse_string(decoded)
	if data != null:
		return data
	else:
		push_warning("Data is null! ", decoded)
		return {}


func remove_file(file_name: String, path: String = "user://") -> void:
	var file_path = path + file_name
	if FileAccess.file_exists(file_path):
		var error: Error = DirAccess.remove_absolute(file_path)
		if error != OK:
			push_error("Failed to remove file at ", file_path, " got error: ", error)
		else:
			DebugMan.dprint("[SaveMan, remove_file] Removed, ", file_path)
