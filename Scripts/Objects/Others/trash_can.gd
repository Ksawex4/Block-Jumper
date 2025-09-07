extends CharacterBody2D

var isColliding: bool = false
@export var isInfinite: bool= false

func _ready() -> void:
	if isInfinite:
		$Sprite2D.texture = load("res://Assets/Sprites/Objects/Others/InfiniteTrashCan.png")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name) != null:
		isColliding = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if NovaFunc.GetPlayerFromGroup(body.name) != null:
		isColliding = false

func _process(_delta: float) -> void:
	if isColliding:
		isColliding = false
		_spawn_spam_guy()
		if !isInfinite:
			queue_free()

func _spawn_spam_guy() -> void:
	var shouldSpawn: float = randf_range(0.0, 10.0)
	if shouldSpawn < 2.0:
		print("[trash_can.gd] Spawned a spamguy")
		var spam: Node2D = preload("res://Scenes/Characters/Enemies/spamguy.tscn").instantiate()
		spam.position = Vector2(position.x + 100, position.y)
		get_tree().current_scene.add_child(spam)
