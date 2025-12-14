extends Node

enum Type {
	AUDIO,
	SPRITE,
	PALETTE,
   }
var Sprites: Dictionary[String, String]
var Audio: Dictionary[String, String]
var Palettes: Dictionary[String, String]
var Load_assets: bool = true


func _ready() -> void:
	load_assets()


func load_assets(path: String="user://Assets") -> void:
	Sprites = {}
	Audio = {}
	if DirAccess.dir_exists_absolute(path):
		var FolderPaths: Array[String]
		var dir := DirAccess.open(path)
		if dir == null:
			push_warning(DirAccess.get_open_error())
			print("Could not open folder", path)
			return
		dir.list_dir_begin()
		for direct: String in dir.get_directories():
			var direct_path := dir.get_current_dir() + "/" + direct
			FolderPaths.append(direct_path)
		# loop loops here and adds all the folder paths in the load assets, if the FolderPaths is bigger than 3 (Sprites, Audio, ColorPalettes) then it breaks
		dir.list_dir_end()
		#print(FolderPaths)
		for folder in FolderPaths:
			dir = DirAccess.open(folder)
			dir.list_dir_begin()
			#print(folder)
			for file: String in dir.get_files():
				var file_path := dir.get_current_dir() + "/" + file
				add_to_correct_dict(file_path)
				#print(file_path)
			dir.list_dir_end()
		#print("Audio:")
		#print(Audio)
		#print("Sprites:")
		#print(Sprites)
		#print("Palettes:")
		#print(Palettes)
		# loops through the folders and check the extension, if .wav or .ogg, `Audio.set(file_name, preload(file_path))`, if .png, .jpg .bmp `Sprites.set(file_name, preload(file_path))`, if .webp `Palettes.set(file_name, preload(file_path))` otherwise its ignored


func add_to_correct_dict(file_path: String) -> void:
	if file_path.ends_with(".wav") or file_path.ends_with(".ogg"):
		Audio.set(file_path.get_file().get_basename(), file_path)
		return
	if file_path.ends_with(".png") or file_path.ends_with(".jpg") or file_path.ends_with(".bmp"):
		Sprites.set(file_path.get_file().get_basename(), file_path)
		return
	if file_path.ends_with(".webp"):
		Palettes.set(file_path.get_file().get_basename(), file_path)
		return

#func get_asset(name: String, type: Type) -> void:


func load_assets_for_node(node: Node2D, file_name: String, type: Type, animation: String="default") -> void:
	if Load_assets:
		match type:
			Type.AUDIO:
				if Audio.has(file_name):
					if FileAccess.file_exists(Audio[file_name]):
						var audio = load_audio(Audio[file_name])
						if audio != null:
							node.stream = audio
						else:
							print("NULL!", Audio[file_name])
					else:
						print("File doesn't exist??", Audio[file_name])
			Type.SPRITE:
				if Sprites.has(file_name):
					if FileAccess.file_exists(Sprites[file_name]):
						var sprite = load_image(Sprites[file_name])
						if sprite != null and node is Sprite2D:
							node.texture = sprite
						else:
							print("NULL!", Sprites[file_name])
					else:
						print("File doesn't exist??", Sprites[file_name])
			Type.PALETTE:
				if Palettes.has(file_name):
					if FileAccess.file_exists(Palettes[file_name]):
						var shader = PaletteMaterial.new()
						var palette = load(Palettes[file_name])
						if palette != null:
							shader.set_palette(load_image(Palettes[file_name]))
							shader.animation_fps = 1
							if node is AnimatedSprite2D:
								shader.animation_fps = node.sprite_frames.get_animation_speed(animation)
							node.material = shader
						else:
							print("NULL!", Palettes[file_name])
					else:
						print("File doesn't exist??", Sprites[file_name])


func load_image(path: String) -> ImageTexture:
	var img = Image.new()
	var err = img.load(path)
	if err != OK:
		push_warning("failed", err)
		return
	var sprite = ImageTexture.create_from_image(img)
	return sprite


func load_audio(path: String) -> Variant: # this doesnt work yet
	var audio
	if path.ends_with(".wav"):
		audio = AudioStreamWAV.load_from_file(path)
	elif path.ends_with(".ogg"):
		audio = AudioStreamOggVorbis.load_from_file(path)
		return
	if audio:
		return audio
	else:
		print("failed", path)
	return
