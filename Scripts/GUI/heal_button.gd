extends Button

@onready var Parent = $".."

func _on_pressed() -> void:
	Parent.heal_player(name)
