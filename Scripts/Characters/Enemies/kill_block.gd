@tool
extends CharacterBody2D
@export var canMove: bool = false
@export var canJump: bool = false
var speed: int = randi_range(7000, 10000)
var jumpHeight: float = randf_range(-300, -450)
var direction: int = [-1, 1].pick_random()
var wallCooldown: float = 0.0

func _ready() -> void:
	if Engine.is_editor_hint():
		if !has_meta("instanceID"):
			_generate_unique_id()
	
	if has_meta("instanceID") and !Engine.is_editor_hint():
		var myUniqueId: String = get_meta("instanceID")
		if LevelMan.PersistenceKeys.has(myUniqueId):
			queue_free()
	else:
		push_error("NO INSTANCE ID")

func _generate_unique_id() -> void:
	var sceneName: String = ""
	if get_owner() and get_owner().get_scene_file_path():
		sceneName = get_owner().get_scene_file_path().get_file().get_basename()
	elif get_scene_file_path():
		sceneName = get_scene_file_path().get_file().get_basename()
	else:
		sceneName = get_name()
	var uniqueSuffix: String = str(hash(get_path()))
	var generatedId: String = "%s_%s" % [sceneName, uniqueSuffix]
	
	set_meta("instanceID", generatedId)

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if canJump and !is_on_floor() or canMove and !is_on_floor():
			velocity.y += LevelMan.Gravity * delta
		if canJump and is_on_floor() and randi_range(1,25) == 6:
			velocity.y = jumpHeight
		if canMove:
			velocity.x = speed * delta * direction
		if is_on_wall() and wallCooldown <= 0.0:
			wallCooldown = 0.2
			direction *= -1
		move_and_slide()
		if wallCooldown > 0.0:
			wallCooldown -= 0.1
