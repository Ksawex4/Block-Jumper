extends MeshInstance2D

@onready var parent = $".."
var pressed := false
@export var maxLenght = 47
@export var deadzone = 5

func _ready() -> void:
	maxLenght *= parent.scale.x

func _process(_delta: float) -> void:
	if pressed:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxLenght:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle) * maxLenght
			global_position.y = parent.global_position.y + sin(angle) * maxLenght
		calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, 0.3)
		parent.posVector = Vector2(0,0)

func calculateVector():
	if abs((global_position.x - parent.global_position.x)) >= deadzone:
		parent.posVector.x = (global_position.x - parent.global_position.x)/maxLenght
	if abs((global_position.y - parent.global_position.y)) >= deadzone:
		parent.posVector.y = (global_position.y - parent.global_position.y)/maxLenght

func _on_button_button_down() -> void:
	pressed = true

func _on_button_button_up() -> void:
	pressed = false
