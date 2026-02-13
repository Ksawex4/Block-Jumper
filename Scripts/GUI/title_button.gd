extends Button

@export var TargetNode: Control
@export var TimerLenght: float = 0.1
@export var TextureId: StringName = &"missing"
var Move: bool = false

func _ready() -> void:
	await get_tree().create_timer(TimerLenght + 0.05).timeout
	Move = true
	icon = NovaTexture.get_texture(TextureId)
	scale = NovaTexture.get_scale(TextureId, NovaTexture.get_texture_size(TextureId), scale)
	NovaTexture.ReloadTexture.connect(_reload_texture)
	


func _physics_process(delta: float) -> void:
	if Move:
		position.x = lerpf(position.x, TargetNode.position.x, 3.0 * delta)


func _reload_texture() -> void:
	scale = NovaTexture.get_scale(TextureId, icon.get_size(), scale)
	icon = NovaTexture.get_texture(TextureId)
	size = Vector2.ZERO
