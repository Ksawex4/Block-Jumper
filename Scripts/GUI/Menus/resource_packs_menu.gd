extends PanelContainer

@export var TranslationsBut: OptionButton
@export var RandomizerSeed: LineEdit
var Randomize: bool = false

func _ready() -> void:
	var saved_packs: Dictionary = SaveMan.get_data_from_file("ActiveResourcePacks.bj", false)
	if !saved_packs.is_empty():
		NovaResourcePack.load_save_data(saved_packs)
	refresh()
	NovaResourcePack.UpdateResourcePacks.connect(refresh)


func refresh() -> void:
	var packs: PackedStringArray = NovaResourcePack.ResourcePacks
	var active_packs: PackedStringArray = NovaResourcePack.ActiveResourcePacks
	var disabled_packs: PackedStringArray = get_disabled_packs(active_packs, [], packs)
	
	spawn_active(active_packs)
	spawn_disabled(disabled_packs)
	
	if TranslationsBut:
		TranslationsBut.clear()
		var translations: PackedStringArray = TranslationServer.get_loaded_locales()
		for trans: String in translations:
			TranslationsBut.add_item(trans)
	print(TranslationServer.get_loaded_locales())

func rescan() -> void:
	NovaResourcePack.load_resource_pack_ids()
	refresh()

func get_disabled_packs(active_packs: PackedStringArray, disabled_packs: PackedStringArray, packs: PackedStringArray) -> PackedStringArray:
	for pack_id in packs:
		if !active_packs.has(pack_id):
			disabled_packs.append(pack_id)
	return disabled_packs

func spawn_active(active_packs: PackedStringArray) -> void:
	var resource_pack_panel: PackedScene = load("uid://n33uotanv1gt")
	var active_packs_container: VBoxContainer = $VSplitContainer/HSplitContainer/ActiveResourcePacks/VBoxContainer
	for child in active_packs_container.get_children():
		child.queue_free()
	
	for pack_id in active_packs:
		var pack_panel: Node = resource_pack_panel.instantiate()
		pack_panel.name = pack_id
		active_packs_container.add_child(pack_panel)
		pack_panel.update_meta(pack_id)

func spawn_disabled(disabled_packs: PackedStringArray) -> void:
	var resource_pack_panel: PackedScene = load("uid://n33uotanv1gt")
	var disabled_packs_container: VBoxContainer = $VSplitContainer/HSplitContainer/DisabledResourcePacks/VBoxContainer
	for child in disabled_packs_container.get_children():
		child.queue_free()
	
	for pack_id in disabled_packs:
		var pack_panel: Node = resource_pack_panel.instantiate()
		pack_panel.name = pack_id
		disabled_packs_container.add_child(pack_panel)
		pack_panel.update_meta(pack_id)

func _on_close_pressed() -> void:
	hide()
	NovaResourcePack.load_active_resource_packs(Randomize, RandomizerSeed.text)
	SaveMan.save_file("ActiveResourcePacks.bj", NovaResourcePack.return_save_data(), false)


func _on_option_button_item_selected(index: int) -> void:
	var locale: String = TranslationsBut.get_item_text(index)
	print("Changed locale to %s" % locale)
	if TranslationServer.has_translation_for_locale(locale, true):
		TranslationServer.set_locale(locale)


func _on_randomize_toggled(toggled_on: bool) -> void:
	Randomize = toggled_on
