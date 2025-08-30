@tool
extends CharacterBody2D

func _ready():
	if Engine.is_editor_hint():
		if !has_meta("instanceID"):
			_generate_unique_id()
	
	if has_meta("instanceID") and !Engine.is_editor_hint():
		var myUniqueId = get_meta("instanceID")
		if LevelMan.PersistenceKeys.has(myUniqueId):
			queue_free()
	else:
		push_error("NO INSTANCE ID")

func _generate_unique_id():
	var sceneName = ""
	if get_owner() and get_owner().get_scene_file_path():
		sceneName = get_owner().get_scene_file_path().get_file().get_basename()
	elif get_scene_file_path():
		sceneName = get_scene_file_path().get_file().get_basename()
	else:
		sceneName = get_name() # Fallback if no scene path
	
	var uniqueSuffix = str(hash(get_path())) # Stable unique hash based on node path
	var generatedId = "%s_%s" % [sceneName, uniqueSuffix]
	
	set_meta("instanceID", generatedId)
