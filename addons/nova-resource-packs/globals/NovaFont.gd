extends Node

var Fonts: Dictionary[StringName, FontFile]
signal ReloadFont()


func add_font(id: StringName, path: String) -> void:
	var extension: String = path.get_extension()
	var font: FontFile
	match extension:
		"fnt", "font":
			font = load_bitmap_font_from_file(path)
		"ttf", "otf", "woff", "woff2", "pfb", "pfm":
			font = load_dynamic_font_from_file(path)
		_:
			print("%s not supported, try using one of these: .fnt .font .ttf .otf .woff .woff2 .pfb .pfm")
	
	if font != null:
		Fonts.set(id, font)
	else:
		push_warning("Font is not valid, new FontFile added as id %s" % id)
		Fonts.set(id, FontFile.new())


func load_bitmap_font_from_file(path: String) -> FontFile:
	var exists: bool = (
		(FileAccess.file_exists(path) and path.begins_with("user://"))
		or (ResourceLoader.exists(path)) and path.begins_with("res://"))
	if !exists:
		push_warning("File doesn't exist, path: %s, returning null" % path)
		return null
	
	if path.begins_with("res://"):
		return load(path)
	
	var font_file: FontFile = FontFile.new()
	var err: Error = font_file.load_bitmap_font(path)
	if font_file != null and err == OK:
		return font_file
	
	push_warning("Failed to load font at %s" % path)
	return null


func load_dynamic_font_from_file(path: String) -> FontFile:
	var exists: bool = (
		(FileAccess.file_exists(path) and path.begins_with("user://"))
		or (ResourceLoader.exists(path)) and path.begins_with("res://"))
	if !exists:
		push_warning("File doesn't exist, path: %s, returning null" % path)
		return null
	
	if path.begins_with("res://"):
		return load(path)
	
	var font_file: FontFile = FontFile.new()
	var err: Error = font_file.load_dynamic_font(path)
	if font_file != null and err == OK:
		return font_file
	
	push_warning("Failed to load font at %s" % path)
	return null


func get_font(id: StringName) -> FontFile:
	if Fonts.has(id):
		return Fonts[id]
	push_warning("Font with id %s doesn't exist, returning new FontFile")
	return FontFile.new()


func load_fonts(fonts: Dictionary, fonts_path: String) -> void:
	print("Loading fonts")
	for font_id in fonts:
		add_font(font_id, fonts_path + fonts[font_id])


func load_base_fonts(data: Dictionary = {}) -> void:
	Fonts = {}
	if data.is_empty():
		data = NovaResourcePack.get_pack_data()
	
	if data.is_empty():
		push_warning("Base pack data is empty!")
		return
	
	var assets_path: String = data.get("assets-path", "")
	if assets_path.is_empty():
		push_warning("Base pack 'assets-path' is empty. Its recommended to add one for the base pack than typing every full path")
	var fonts_path: String = assets_path + data.get("fonts-path", "")
	
	var fonts: Dictionary = data.get("fonts", {})
	load_fonts(fonts, fonts_path)
