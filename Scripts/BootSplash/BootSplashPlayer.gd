extends AnimatedSprite2D

@onready var parent := $".."
@export var targetPos := [Vector2(0.0, 0.0), Vector2(0.0, 0.0)]
@export var hasLeftRightAnim := false
var currentIndex := 0
var laps := 0

func _ready() -> void:
	play("default")

func _physics_process(_delta: float) -> void:
	if parent.PlayersWalk:
		if position == targetPos[currentIndex]:
			currentIndex = 1 if currentIndex == 0 else 0
			position.y = targetPos[currentIndex].y
			laps = laps + 1 if currentIndex == 0 else laps
		elif laps != 1: 
			if position.x < targetPos[currentIndex].x:
				position.x += 2
				if hasLeftRightAnim:
					play("right")
			elif position.x > targetPos[currentIndex].x:
				position.x -= 2
				if hasLeftRightAnim:
					play("left")
		else:
			parent.Continue = true
