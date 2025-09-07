extends CharacterBody2D

func _ready() -> void:
	if PlayerStats.Chip:
		print("[chip.gd, ", self.name, "] Removed Chip beacuse player got it before") 
		queue_free()

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += LevelMan.Gravity * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name) != null:
		PlayerStats.Chip = true
		print("[chip.gd, ", self.name, "] Got picked up by player")
		queue_free()
