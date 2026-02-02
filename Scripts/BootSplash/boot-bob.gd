extends "res://addons/nova-resource-packs/nodes/texture/NovaSprite2D.gd"

enum States {
	NONE,
	GO,
	SPIN,
}
@export var Parent: Node2D
@export var RotationSpeed: float = 1.0
@export var Radius: float = 64.0
@export var CenterPoint: Vector2 = Vector2.ZERO
@export var Angle: float = 0.0
var State: States = States.NONE
var TargetPos: Vector2 = Vector2.ZERO


func _nova_ready() -> void:
	await Parent.BobsSpin
	State = States.GO


func _physics_process(delta: float) -> void:
	match State:
		States.GO:
			position.y = lerp(position.y, -32.0, 12.0 * delta)
			if round(position.y) == -32:
				State = States.SPIN
		
		States.SPIN:
			Angle += RotationSpeed * delta
			var my_offset: Vector2 = Vector2(cos(Angle), sin(Angle)) * Radius
			TargetPos = CenterPoint + my_offset
			position = lerp(position, TargetPos, 12.0 * delta)
			look_at(CenterPoint)
