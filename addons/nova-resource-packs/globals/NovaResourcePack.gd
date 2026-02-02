extends Node

var ResourcePacks: PackedStringArray = [BASE_PACK_ID]
var ActiveResourcePacks: PackedStringArray = [BASE_PACK_ID]
const BASE_PACK_ID = "base"
const BASE_PACK_DATA_PATH = "res://Assets/data.json" # Path to data.json of the default resource pack
const RESOURCE_PACKS_PATH = "user://resource-packs"
const RESOURCE_PACK_DATA_PATH = RESOURCE_PACKS_PATH + "/%s/data.json"

func _ready() -> void:
	load_base_assets()
	load_resource_pack_ids()
	activate_resource_pack("test-pack")
	activate_resource_pack("emix-pack")
	load_active_resource_packs()


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
	load_resource_pack_ids()
	if ResourcePacks.has(id) and !ActiveResourcePacks.has(id):
		ActiveResourcePacks.append(id)


func disable_resource_pack(id: String) -> void:
	if ActiveResourcePacks.has(id) and id != BASE_PACK_ID:
		ActiveResourcePacks.erase(id)
	
	if !ResourcePacks.has(id):
		ResourcePacks.erase(id)


func return_save_data() -> Dictionary:
	return {
		"ActiveResourcePacks": ActiveResourcePacks
	}


func load_save_data(data: Dictionary) -> void:
	ActiveResourcePacks = data.get("ActiveResourcePacks", [BASE_PACK_ID])
	load_active_resource_packs()


func load_active_resource_packs() -> void:
	print("Loading packs: ",ActiveResourcePacks)
	#load_base_assets()
	
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
	
	print("======== Loading resource packs ========")
	NovaTexture.load_textures(assets[&"textures"], "")
	NovaAnimation.load_animations_data(assets[&"animations"])
	NovaTranslation.load_locales(assets[&"langs"], "")
	NovaAudio.load_sfx(assets[&"audio"][&"sfx"], "")
	NovaAudio.load_music(assets[&"audio"][&"music"], "")
	NovaFont.load_fonts(assets[&"fonts"], "")
	
	print("======== Loaded packs %s ========" % ActiveResourcePacks)
	
	NovaTexture.ReloadTexture.emit()
	NovaAnimation.ReloadAnimation.emit()
	NovaAudio.ReloadSfx.emit()
	NovaAudio.ReloadMusic.emit()
	NovaFont.ReloadFont.emit()


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
