extends CharacterBody2D

func _ready() -> void:
	if PlayerStats.Chip:
		queue_free()


func _physics_process(_delta) -> void:
	if not is_on_floor():
		velocity.y += LevelMan.Gravity
	move_and_slide()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	PlayerStats.Chip = true
	queue_free()
