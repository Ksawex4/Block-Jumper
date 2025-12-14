extends AnimatedSprite2D

enum Direction { LEFT, RIGHT }
@onready var Parent := $".."
@export var Target_pos := [Vector2(403.0, -149.0), Vector2(-389.0, 182.0)]
@export var Has_left_right_anim := false
@export var Is_player := true
var My_direction: Direction = Direction.RIGHT
var Current_index := 0
var Laps := 0


func _ready() -> void:
	play("default")


func _physics_process(delta: float) -> void:
	if Parent.Players_walk:
		if Laps != 1:
			if My_direction == Direction.RIGHT and position.x < Target_pos[Current_index].x:
				position.x += 120 * delta
				if Has_left_right_anim:
					play("right")
			elif My_direction == Direction.LEFT and position.x > Target_pos[Current_index].x:
				position.x -= 120 * delta
				if Has_left_right_anim:
					play("left")
			else:
				change_direction()
		else:
			Parent.Continue = true


func change_direction() -> void:
	Current_index = 1 if Current_index == 0 else 0
	position.y = Target_pos[Current_index].y
	Laps += 1 if Current_index == 0 else 0
	My_direction = Direction.RIGHT if Current_index == 0 else Direction.LEFT


func _on_button_pressed() -> void:
	if not $Explosion.is_playing():
		$Explosion.show()
		$Explosion.play("default")
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.8, 1.5)
		$AudioStreamPlayer2D.play()
		self_modulate.a = 0.0
		DebugMan.dprint("[" + name + ", _on_button_pressed] Pressed")


func _on_explosion_animation_finished() -> void:
	Parent.Exploded_players += 1
	queue_free()
	DebugMan.dprint("[" + name + ", _on_explosion_animation_finished] Exploded")
