extends Node2D

var Semi_global


func _ready() -> void:
	if ResourceLoader.exists("res://Resources/testing/semi-global.gd"):
		Semi_global = ResourceLoader.load("res://Resources/testing/semi-global.gd").new()


func _physics_process(delta: float) -> void:
	Semi_global.exist()