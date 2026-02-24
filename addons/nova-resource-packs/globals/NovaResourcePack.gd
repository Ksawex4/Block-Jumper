extends Node

var ResourcePacks: PackedStringArray = [BASE_PACK_ID]
var ActiveResourcePacks: PackedStringArray = [BASE_PACK_ID]
const BASE_PACK_ID = "base"
const BASE_PACK_DATA_PATH = "res://Assets/data.json" # Path to data.json of the default resource pack
const RESOURCE_PACKS_PATH = "user://resource-packs"
const RESOURCE_PACK_DATA_PATH = RESOURCE_PACKS_PATH + "/%s/data.json"
signal UpdateResourcePacks()

func _ready() -> void:
	load_base_assets()
	load_resource_pack_ids()


func load_base_assets() -> void:
	print("Loading pack: %s" % BASE_PACK_ID)
	var base_data: Dictionary = get_pack_data()
	NovaTranslation.load_base_translations(base_data)
	NovaTexture.load_base_textures(base_data)
	NovaAnimation.load_base_animations(base_data)
	NovaAudio.load_base_audio(base_data)
	NovaFont.load_base_fonts(base_data)
	print("============ Loaded %s ==============" % BASE_PACK_ID)


func load_resource_pack_ids() -> void:
	var packs: PackedStringArray
	
	if !DirAccess.dir_exists_absolute(RESOURCE_PACKS_PATH):
		DirAccess.make_dir_recursive_absolute(RESOURCE_PACKS_PATH)
	
	var directories: PackedStringArray = DirAccess.get_directories_at(RESOURCE_PACKS_PATH)
	packs.append_array(directories)
	var verified_packs: PackedStringArray = [BASE_PACK_ID]
	for x in packs:
		if x == BASE_PACK_ID:
			push_warning("User pack id %s is the same as base pack id, skipping" % x)
			continue
		
		if verified_packs.has(x):
			push_warning("User pack id %s already exists in resource packs, change pack folder name" % x)
			continue
		
		verified_packs.append(x)
	ResourcePacks = verified_packs


## Returns empty on fail 
func get_pack_data(id: String = BASE_PACK_ID) -> Dictionary:
	var pack_data_path: String = RESOURCE_PACK_DATA_PATH % id
	if id == BASE_PACK_ID:
		pack_data_path = BASE_PACK_DATA_PATH
	if !FileAccess.file_exists(pack_data_path):
		push_warning("data.json doesn't exist for id: %s path: %s " % [id, pack_data_path])
		return {}
	
	var file: FileAccess = FileAccess.open(pack_data_path, FileAccess.READ)
	var err: Error = FileAccess.get_open_error()
	if err != OK:
		push_warning("Failed to open data.json at %s got error: %s" % [pack_data_path, err])
		return {}
	
	var data: Dictionary = JSON.parse_string(file.get_as_text())
	file.close()
	
	return data


func activate_resource_pack(id: String) -> void:
	if ResourcePacks.has(id) and !ActiveResourcePacks.has(id):
		ActiveResourcePacks.append(id)
		UpdateResourcePacks.emit()
		print("Activated pack %s" % id)


func disable_resource_pack(id: String) -> void:
	if ActiveResourcePacks.has(id) and id != BASE_PACK_ID:
		ActiveResourcePacks.erase(id)
		UpdateResourcePacks.emit()
		print("Disabled pack %s" % id)


func set_active_packs(array: PackedStringArray) -> void:
	if !array.has(BASE_PACK_ID):
		var old_array: PackedStringArray = array
		array = [BASE_PACK_ID]
		array.append_array(old_array)
	
	if !array.is_empty():
		ActiveResourcePacks = array
		UpdateResourcePacks.emit()


func set_resource_packs(array: PackedStringArray) -> void:
	if !array.is_empty():
		ResourcePacks = array
		UpdateResourcePacks.emit()


func return_save_data() -> Dictionary:
	return {
		"ActiveResourcePacks": ActiveResourcePacks
	}


func load_save_data(data: Dictionary) -> void:
	set_active_packs(data.get("ActiveResourcePacks", []))
	load_active_resource_packs()


func load_active_resource_packs(randomize: bool = false, rseed: int = -1) -> void:
	print("======== Loading packs: %s ========" % ActiveResourcePacks)
	
	var assets: Dictionary[StringName, Dictionary] = {
		&"textures": {},
		&"animations": {},
		&"audio": {
			&"sfx": {},
			&"music": {},
		},
		&"langs": {},
		&"fonts": {},
	}
	for id in ActiveResourcePacks:
		print("======== Merging resource pack %s ========" % id)
		assets = _merge_data(assets, get_pack_data(id), id)
	
	if randomize:
		var randomizer: RandomNumberGenerator = RandomNumberGenerator.new()
		if rseed == -1:
			randomizer.seed = randf_range(
				-150000.0,
				150000.0
			)
		else:
			randomizer.seed = rseed
		print("Randomizer seed: %s" % randomizer.seed)
		
		assets[&"textures"] = _randomize_assets(
			assets[&"textures"].keys(),
			assets[&"textures"].values(),
			randomizer
		)[0]
		
		var rand_sfx:  Dictionary[StringName, String]
		var rand_music: Dictionary[StringName, String]
		var audio: Array = assets[&"audio"][&"sfx"].values()
		audio.append_array(assets[&"audio"][&"music"].values())
		var result: Array = _randomize_assets(assets[&"audio"][&"sfx"].keys(), audio, randomizer)
		audio = result[1]
		rand_sfx = result[0]
		rand_music = _randomize_assets(assets[&"audio"][&"music"].keys(), audio, randomizer)[0]
		assets[&"audio"][&"sfx"] = rand_sfx
		assets[&"audio"][&"music"] = rand_music
		
		assets[&"fonts"] = _randomize_assets(assets[&"fonts"].keys(), assets[&"fonts"].values(), randomizer)[0]
		
		for trans_id in assets[&"langs"].keys():
			var lang: Dictionary = assets[&"langs"]
			assets[&"langs"][trans_id] = _randomize_assets(lang.keys(), lang.values(), randomizer)[0]
	
	
	print("======== Loading resource packs ========")
	NovaTexture.load_textures(assets[&"textures"], "")
	NovaAnimation.load_animations_data(assets[&"animations"])
	NovaTranslation.load_locales(assets[&"langs"], "")
	NovaAudio.load_sfx(assets[&"audio"][&"sfx"], "")
	NovaAudio.load_music(assets[&"audio"][&"music"], "")
	NovaFont.load_fonts(assets[&"fonts"], "")
	print("======== Reloading resources %s ========" % ActiveResourcePacks)
	NovaTexture.ReloadTexture.emit()
	NovaAnimation.ReloadAnimation.emit()
	NovaAudio.ReloadSfx.emit()
	NovaAudio.ReloadMusic.emit()
	NovaFont.ReloadFont.emit.call_deferred()
	print("======== Reloaded ========")


## First value is the randomized Dictionary, second value is leftover values
func _randomize_assets(keys: Array, values: PackedStringArray, randomizer: RandomNumberGenerator = RandomNumberGenerator.new()) -> Array:
	var rand_assets: Dictionary[StringName, String] = {}
	for id: StringName in keys:
		var index: int = randomizer.randi_range(0, values.size()-1)
		var value: String = values[index]
		values.remove_at(index)
		rand_assets.set(id, value)
	return [rand_assets, values]


func _get_assets_path(pack_data: Dictionary, pack_id: String) -> String:
	return (pack_data.get("assets-path", "") if pack_id == BASE_PACK_ID 
		else (RESOURCE_PACKS_PATH + "/%s/" % pack_id + pack_data.get("assets-path", "")))


func _merge_data(assets: Dictionary, pack_data: Dictionary, pack_id: String) -> Dictionary:
	var assets_path: String = _get_assets_path(pack_data, pack_id)
	var new_textures: Dictionary = pack_data.get("textures", {})
	var textures_path: String = assets_path + pack_data.get("textures-path", "")
	assets[&"textures"] = _merge_textures(assets[&"textures"], new_textures, textures_path, pack_id)
	
	var new_animations: Dictionary = pack_data.get("animations", {})
	assets[&"animations"] = _merge_animations(assets[&"animations"], new_animations, pack_id, assets[&"textures"])
	
	var sfx_path: String = assets_path + pack_data.get("sfx-path", "")
	var music_path: String = assets_path + pack_data.get("music-path", "")
	var new_audio: Dictionary = pack_data.get("audio", {})
	assets[&"audio"] = _merge_audio(assets[&"audio"], new_audio, sfx_path, music_path, pack_id)
	
	var langs_path: String = assets_path + pack_data.get("langs-path", "")
	var new_langs: Dictionary = pack_data.get("langs", {})
	assets[&"langs"] = _merge_langs(assets[&"langs"], new_langs, langs_path, pack_id)
	
	var fonts_path: String = assets_path + pack_data.get("fonts-path", "")
	var new_fonts: Dictionary = pack_data.get("fonts", {})
	assets[&"fonts"] = _merge_fonts(assets[&"fonts"], new_fonts, fonts_path, pack_id)
	
	return assets


func _file_exists(path: String) -> bool:
	return (( path.begins_with("res://") and ResourceLoader.exists(path) ) or
			( path.begins_with("user://") and FileAccess.file_exists(path) ))


func _merge_textures(textures: Dictionary, new_textures: Dictionary, textures_path: String, pack_id: String) -> Dictionary:
	for id: StringName in new_textures.keys():
		var texture_path: String = textures_path + new_textures[id]
		if _file_exists(texture_path):
			textures.set(id, texture_path)
		else:
			push_warning("Pack id: %s, Texture id: %s File doesn't exist at path: %s" % [pack_id, id, texture_path])
	
	return textures

func _merge_animations(animations: Dictionary, new_animations: Dictionary, pack_id: String, textures: Dictionary) -> Dictionary:
	for id: StringName in new_animations.keys():
		var animation_data: Dictionary = new_animations[id]
		var anim_type: String = animation_data.get("type", "")
		match anim_type:
			"sheet":
				var texture_id: StringName = animation_data.get("texture-id", "")
				if texture_id.is_empty():
					print(animation_data)
					push_warning("Pack id: %s, Animation id: %s, Texture id %s is empty" % [pack_id, id, texture_id])
					continue
				elif !textures.has(texture_id):
					push_warning("Pack id: %s, Animation id: %s Texture with id %s doesn't exist/is loaded, if its from a different pack, move it above this one" % [pack_id, id, texture_id])
					continue
			"frames":
				var texture_ids: PackedStringArray = animation_data.get("texture-id", [])
				var failed: bool = false
				for texture_id in texture_ids:
					if texture_id.is_empty():
						push_warning("Pack id: %s, Animation id: %s")
						failed = true
					elif !textures.has(texture_id):
						push_warning("Pack id: %s, Animation id: %s Texture with id %s doesn't exist/is loaded, if its from a different pack, move it above this one" % [pack_id, id, texture_id])
						failed = true
				
				if failed:
					continue
			_:
				push_warning("Pack id: %s, Animation id: %s Wrong type: %s, use type 'sheets' for a sprite sheet or 'frames' for individual frames" % [pack_id, id, anim_type])
				continue
		
		animations.set(id, animation_data)
	
	return animations

func _merge_audio(audio: Dictionary, new_audio: Dictionary, sfxs_path: String, musics_path: String, pack_id: String) -> Dictionary:
	for audio_type: StringName in new_audio.keys():
		match audio_type:
			&"sfx":
				for id: StringName in new_audio[audio_type].keys():
					var sfx_path: String = sfxs_path + new_audio[audio_type][id]
					if _file_exists(sfx_path):
						audio[audio_type].set(id, sfx_path)
					else:
						push_warning("Pack id: %s, Sfx id: %s File doesn't exist at path: %s" % [pack_id, id, sfx_path])
			&"music":
				for id: StringName in new_audio[audio_type].keys():
					var music_path: String = musics_path + new_audio[audio_type][id]
					if _file_exists(music_path):
						audio[audio_type].set(id, music_path)
					else:
						push_warning("Pack id: %s, Music id: %s File doesn't exist at path: %s" % [pack_id, id, music_path])
	
	return audio

func _merge_langs(langs: Dictionary, new_langs: Dictionary, langs_path: String, pack_id: String) -> Dictionary:
	for id: StringName in new_langs.keys():
		var lang_value = new_langs[id]
		if typeof(lang_value) == TYPE_STRING:
			var lang_path: String = langs_path + lang_value
			if _file_exists(lang_path):
				langs.set(id, lang_path)
			else:
				push_warning("Pack id: %s, Lang id: %s File doesn't exist at path: %s" % [pack_id, id, lang_path])
		elif typeof(lang_value) == TYPE_DICTIONARY:
			langs.set(id, lang_value)
		else:
			push_warning("Pack id: %s, Lang id: %s Wrong type, should be String(path) or Dictionary[String, String]" % [pack_id, id])
	
	return langs

func _merge_fonts(fonts: Dictionary, new_fonts: Dictionary, fonts_path: String, pack_id: String) -> Dictionary:
	for id: StringName in new_fonts.keys():
		var font_path: String = fonts_path + new_fonts[id]
		if _file_exists(font_path):
			fonts.set(id, font_path)
		else:
			push_warning("Pack id: %s, Font id: %s File doesn't exist at path: %s" % [pack_id, id, font_path])
	
	return fonts


func remove_pack(pack_id: String) -> void:
	var pack_directory: String = RESOURCE_PACKS_PATH + "/%s" % pack_id
	if DirAccess.dir_exists_absolute(pack_directory):
		if ActiveResourcePacks.has(pack_id):
			disable_resource_pack(pack_id)
		
		var dirs: PackedStringArray = get_all_files(pack_directory, [], true)
		dirs = _sort_by_deepness(dirs)
		for dir in dirs:
			var files: PackedStringArray = get_all_files(dir)
			files = get_all_files(dir, files, true)
			for file in files:
				DirAccess.remove_absolute(file)
			DirAccess.remove_absolute(dir)
		
		var pack_files: PackedStringArray = get_all_files(pack_directory)
		for file in pack_files:
			DirAccess.remove_absolute(file)
		DirAccess.remove_absolute(pack_directory)


func _sort_by_deepness(array: PackedStringArray) -> PackedStringArray:
	var sorted: Array = array.duplicate()
	sorted.sort_custom(func(a: String, b: String) -> bool:
		return a.count("/") > b.count("/")
	)
	
	return PackedStringArray(array)


func get_all_files(path: String, files: PackedStringArray = PackedStringArray([]), get_dirs: bool=false) -> PackedStringArray:
	var dir := DirAccess.open(path)
	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir() and not get_dirs:
				files = get_all_files(dir.get_current_dir() + "/%s" % file_name, files)
			else:
				if get_dirs and dir.current_is_dir() or not get_dirs and not dir.current_is_dir():
					files.append(dir.get_current_dir()+ "/%s" % file_name)
			file_name = dir.get_next()
	else:
		print("Failed to open dir at ", path)
	
	return files
