extends Node
const DEFAULT_LOCALE = "en_us"


func load_base_translations(data: Dictionary = {}) -> void:
	if data.is_empty():
		data = NovaResourcePack.get_pack_data()
	
	if data.is_empty():
		push_warning("Base pack data is empty!")
		return
	
	var assets_path: String = data.get("assets-path", "")
	if assets_path.is_empty():
		push_warning("Base pack 'assets-path' is empty. Its recommended to add one for the base pack than typing every full path")
	var langs_path: String = assets_path + data.get("langs-path", "")
	
	var translations: Dictionary = data.get("langs", {})
	print("Loading translation pack: %s" % NovaResourcePack.BASE_PACK_ID)
	load_locales(translations, langs_path)


func load_locales(translations: Dictionary, langs_path: String) -> void:
	print("Loading translations")
	for locale: String in translations:
		var translation = translations[locale]
		if typeof(translation) == TYPE_STRING:
			translation = _get_translation_from_file(langs_path + translation)
		elif typeof(translation) != TYPE_DICTIONARY:
			push_warning("Unsuported type for locale %s, should be String(path) or Dictionary" % locale)
			continue
		
		var trans: Translation = (
			Translation.new() if TranslationServer.get_translation_object(locale) == null 
			else TranslationServer.get_translation_object(locale)
		)
		trans.locale = locale
		
		for key: String in translation.keys():
			trans.add_message(key, translation[key])
		
		TranslationServer.remove_translation(TranslationServer.get_translation_object(locale))
		TranslationServer.add_translation(trans)
	TranslationServer.reload_pseudolocalization()


func _get_translation_from_file(path: String) -> Dictionary:
	if !FileAccess.file_exists(path):
		push_warning("File doesn't exist at path %s" % path)
		return {}
	
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var err: Error = FileAccess.get_open_error()
	if err != OK:
		push_warning("Failed to open file at path %s got error %s" % [path, err])
		return {}
	
	var json_string: String = file.get_as_text()
	file.close()
	
	if json_string.is_empty():
		push_warning("File is empty at path %s" % path)
		return {}
	
	var data: Dictionary = JSON.parse_string(json_string)
	
	if data == null:
		push_warning("Failed to parse file at path %s" % path)
		return {}
	
	return data
