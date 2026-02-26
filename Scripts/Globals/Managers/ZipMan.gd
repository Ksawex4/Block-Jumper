extends Node

func unzip_to_directory(path_to_zip: String, unzip_path: String="user://") -> void:
	var reader := ZIPReader.new()
	if not FileAccess.file_exists(path_to_zip):
		push_warning("file_doesn't exist ", path_to_zip)
		return
	
	if not DirAccess.dir_exists_absolute(unzip_path):
		DirAccess.make_dir_recursive_absolute(unzip_path)
	
	var root_dir := DirAccess.open(unzip_path)
	
	reader.open(path_to_zip)
	var files := reader.get_files()
	for file_path in files:
		if file_path.ends_with("/"):
			root_dir.make_dir_recursive(file_path)
			continue
		
		root_dir.make_dir_recursive(root_dir.get_current_dir().path_join(file_path).get_base_dir())
		var file = FileAccess.open(root_dir.get_current_dir().path_join(file_path), FileAccess.WRITE)
		var buffer = reader.read_file(file_path)
		file.store_buffer(buffer)
