extends Sprite2D

@onready var parent = $".."
@export var rotation_speed: float = 0.2
@export var radius: float = 128
@export var center_point: Vector2 = Vector2(0, 0)
@export var angle: float = 0.0
var spin := false

func _physics_process(delta: float) -> void:
	if parent.BobsSpin:
		if round(position.y) == -32 and not spin:
			spin = true
		elif round(position.y) != -32 and not spin:
			position.y = lerp(position.y, -32.0, 0.2)
	
	if spin:
		angle += rotation_speed * delta
		var myOffset = Vector2(cos(angle), sin(angle)) * radius
		position = center_point + myOffset
		look_at(Vector2(0,0))
