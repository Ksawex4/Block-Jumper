extends CharacterBody2D

@export var Damage := 50
var Speed: int = 100
var Direction: int = 1
var Wall_stop: bool = false

func _ready() -> void:
	AchievMan.add_achievement("Trash")
	var texture_id: StringName = &"missing"
	match randi_range(0,4):
		0:
			$BDSpamguy.disabled = false
			texture_id = &"enemy-badly-drawn-spamton"
			Speed = 70
		1:
			$Brunton1.disabled = false
			texture_id = &"enemy-brunton.1"
			Speed = 130
		2:
			$Brunton2.disabled = false
			texture_id = &"enemy-brunton.2"
		3:
			$Ksawton.disabled = false
			texture_id = &"enemy-ksawton"
			Speed = 100
		4:
			$BDSpamQueen.disabled = false
			texture_id = &"enemy-badly-drawn-spam-queen"
			Speed = 117
	
	$Sprite2D.change_texture(texture_id)
	# removing not needed hitboxes
	for x in get_children():
		if x is CollisionShape2D and x.disabled:
			x.queue_free()


func _physics_process(_delta: float) -> void:
	if not is_on_floor():
		velocity.y += LevelMan.Gravity
	if not Wall_stop and is_on_wall():
		Wall_stop = true
		Direction *= -1
	if Wall_stop and not is_on_wall():
		Wall_stop = false
	
	velocity.x = Speed * Direction
	move_and_slide()


func take_damage(_damage: int) -> void:
	AchievMan.add_achievement("SpamKiller")
	queue_free()
