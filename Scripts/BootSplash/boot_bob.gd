extends Sprite2D

@onready var Parent = $".."
@export var Rotation_speed: float = 1.0
@export var Radius: float = 64.0
@export var Center_point: Vector2 = Vector2(0, 0)
@export var Angle: float = 0.0
var Spin := false

func _physics_process(delta: float) -> void:
	if Parent.Bobs_spin:
		if round(position.y) == -32 and not Spin:
			Spin = true
		elif round(position.y) != -32 and not Spin:
			position.y = lerp(position.y, -32.0, 0.2)
	
	if Spin:
		Angle += Rotation_speed * delta
		var my_offset = Vector2(cos(Angle), sin(Angle)) * Radius
		position = Center_point + my_offset
		look_at(Vector2(0,0))
