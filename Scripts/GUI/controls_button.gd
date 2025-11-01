extends Button

@export var keybind := "FencyJump"
@onready var parent := $".."

func _on_pressed() -> void:
	parent.keybind = keybind
	parent.waitingForInput = true
