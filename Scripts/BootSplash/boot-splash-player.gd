extends AnimatedSprite2D

enum Directions {
	NONE,
	LEFT,
	RIGHT
}
@export var Parent: Node2D
@export var TargetPositions: Array[Vector2] = [Vector2.ZERO, Vector2.ZERO]
@export var IsPlayer: bool = true
@export var HasLeftRightAnimation: bool = false
var Direction: Directions = Directions.NONE
var Exploded: bool = false


func _ready() -> void:
	await Parent.PlayersMove
	Direction = Directions.RIGHT
	play("default")


func _physics_process(delta: float) -> void:
	var targetX = TargetPositions[0].x if Direction == Directions.RIGHT else TargetPositions[1].x
	match Direction:
		Directions.RIGHT:
			if HasLeftRightAnimation:
				play("right")
			position.x += 120 * delta
			if position.x >= targetX:
				position.x = targetX
				position.y = TargetPositions[1].y
				Direction = Directions.LEFT
		
		Directions.LEFT:
			if HasLeftRightAnimation:
				play("left")
			position.x -= 120 * delta
			if position.x <= targetX:
				position.x = targetX
				Direction = Directions.NONE
				Parent.ShowGameTitle.emit()
		
		Directions.NONE:
			if !IsPlayer and Exploded:
				position.y = lerp(position.y, -240.0, 5.0 * delta)


func _on_button_pressed() -> void:
	if IsPlayer and !Exploded:
		_explode()
		await get_tree().create_timer(0.3).timeout
		self_modulate.a = 0.0
		await $Explosion.animation_finished
		Parent.PlayerExploded.emit()
		queue_free()
	elif !IsPlayer and !Exploded:
		Exploded = true
		Direction = Directions.NONE

func _explode() -> void:
	Exploded = true
	if IsPlayer:
		$Explosion.visible = true
		$Explosion.play("default")
		$AudioStreamPlayer2D.play()
	else:
		Direction = Directions.NONE
	
