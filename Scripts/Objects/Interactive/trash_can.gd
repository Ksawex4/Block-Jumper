extends Area2D

@export var Is_infinite: bool = false
var Infinite_texture := preload("uid://tj0qpeprurae")
var Spamguy := preload("uid://cqx8mt1calvhl")


func _ready() -> void:
	if Is_infinite:
		$Sprite2D.texture = Infinite_texture


func _on_body_entered(_body: Node2D) -> void:
	spawn_spamguy()


func spawn_spamguy() -> void:
	if randf_range(0.0, 10.0) < 2.0:
		var spam = Spamguy.instantiate()
		spam.global_position = global_position + Vector2(100, 0)
		get_tree().current_scene.call_deferred("add_child", spam)
	
	if not Is_infinite:
		queue_free()
