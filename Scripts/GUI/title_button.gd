extends Button

@export var TargetNode: Control
@export var TimerLenght: float = 0.1
var Move: bool = false

func _ready() -> void:
	await get_tree().create_timer(TimerLenght + 0.05).timeout
	Move = true


func _physics_process(delta: float) -> void:
	if Move:
		position.x = lerpf(position.x, TargetNode.position.x, 3.0 * delta)
