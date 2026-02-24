extends PanelContainer

@export var Icon: TextureRect
@export var Name: Label
@export var Authors: Label
@export var Description: Label
@export var TexturesCount: Label
@export var AudioCount: Label
@export var FontsCount: Label
@export var TranslationsCount: Label
@export var AreYaSurePopup: PopupMenu
var Active: bool = false
var PackId: String = ""

func update_meta(pack_id: String = "") -> void:
	PackId = pack_id
	var pack_data: Dictionary = NovaResourcePack.get_pack_data(pack_id)
	var pack_meta: Dictionary = pack_data.get("meta", {})
	
	Active = NovaResourcePack.ActiveResourcePacks.has(pack_id)
	Name.text = pack_meta.get("name", "Failed to get name")
	Description.text = pack_meta.get("description", "Failed to load description")
	Authors.text = "Authors: "
	var authors: Array = pack_meta.get("authors", ["Missing"])
	for author: String in authors:
		Authors.text += author + ", "
	Authors.text = Authors.text.erase(Authors.text.length()-2, 2)
	
	var icon_filename: String = pack_meta.get("icon", "")
	if !icon_filename.is_empty():
		Icon.texture = (
			NovaTexture.get_texture_from_file(NovaResourcePack.RESOURCE_PACKS_PATH + "/%s/" % pack_id + icon_filename)
			if pack_id != NovaResourcePack.BASE_PACK_ID else
			NovaTexture.get_texture_from_file(icon_filename)
		)
	
	var audio_data: Dictionary = pack_data.get("audio", {})
	TexturesCount.text = "Textures: %s" % pack_data.get("textures", {}).size()
	AudioCount.text = "Audio: %s" % (audio_data.get("sfx", {}).size() + audio_data.get("music", {}).size())
	FontsCount.text = "Fonts: %s" % pack_data.get("fonts", {}).size()
	TranslationsCount.text = "Translations: %s" % pack_data.get("langs", {}).size()
	
	if pack_id == NovaResourcePack.BASE_PACK_ID:
		if $VSplitContainer/GridContainer/Delete:
			$VSplitContainer/GridContainer/Delete.queue_free()
		if $VSplitContainer/GridContainer/ShowDir:
			$VSplitContainer/GridContainer/ShowDir.queue_free()
		if $VSplitContainer/GridContainer/Toggle:
			$VSplitContainer/GridContainer/Toggle.queue_free()


func _on_toggle_pressed() -> void:
	if Active:
		NovaResourcePack.disable_resource_pack(PackId)
	else:
		NovaResourcePack.activate_resource_pack(PackId)


func _on_show_dir_pressed() -> void:
	if PackId == NovaResourcePack.BASE_PACK_ID:
		return
	
	var pack_path: String = NovaResourcePack.RESOURCE_PACKS_PATH + "/%s/" % PackId
	OS.shell_open(ProjectSettings.globalize_path(pack_path))


func move_pack(array: Array, direction: int = -1, value = "") -> Array:
	var value_pos: int = array.find(value)
	if value_pos == -1 or value_pos + 1 + direction > array.size() or value_pos + direction < 0:
		return array
	
	var other_pos: int = value_pos + direction
	var other_value = array[other_pos]
	
	array[value_pos] = other_value
	array[other_pos] = value
	return array


func get_disabled_packs(active_packs: PackedStringArray, disabled_packs: PackedStringArray, packs: PackedStringArray) -> PackedStringArray:
	for pack_id in packs:
		if !active_packs.has(pack_id) and !disabled_packs.has(pack_id):
			disabled_packs.append(pack_id)
	return disabled_packs


func _on_move_up_pressed() -> void:
	var array: Array = (
		NovaResourcePack.ActiveResourcePacks if Active else 
		get_disabled_packs(NovaResourcePack.ActiveResourcePacks, [], NovaResourcePack.ResourcePacks)
	)
	
	array = move_pack(array, -1, PackId)
	if Active:
		NovaResourcePack.set_active_packs(array)
	else:
		NovaResourcePack.set_resource_packs(array)


func _on_move_down_pressed() -> void:
	var array: Array = (
		NovaResourcePack.ActiveResourcePacks if Active else 
		get_disabled_packs(NovaResourcePack.ActiveResourcePacks, [], NovaResourcePack.ResourcePacks)
	)
	array = move_pack(array, 1, PackId)
	if Active:
		NovaResourcePack.set_active_packs(array)
	else:
		NovaResourcePack.set_resource_packs(array)


func _on_delete_pressed() -> void:
	AreYaSurePopup.popup_centered()
	var selected: int = await AreYaSurePopup.index_pressed
	if selected == 1:
		NovaResourcePack.remove_pack(PackId)
		queue_free()
