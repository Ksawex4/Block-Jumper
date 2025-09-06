@tool
extends CharacterBody2D
var gaveBean = false
var toast = false
@export var canMove := false
@export var canJump := false
var speed = randi_range(7000, 10000)
var jumpHeight = randf_range(-300, -450)
var direction = [-1, 1].pick_random()
var wallCooldown = 0.0

func _ready():
	if Engine.is_editor_hint():
		if !has_meta("instanceID"):
			_generate_unique_id()
	
	if has_meta("instanceID") and !Engine.is_editor_hint():
		var myUniqueId = get_meta("instanceID")
		if LevelMan.PersistenceKeys.has(myUniqueId):
			queue_free()
		$AnimatedSprite2D.play()
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

func _physics_process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if !is_on_floor():
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
		
		if LevelMan.BeansAreToasts and !toast:
			$AnimatedSprite2D.play("Toast")
			toast = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name) and !gaveBean:
		gaveBean = true
		PlayerStats.AddBeans(1)
		queue_free()
