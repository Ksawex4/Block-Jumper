extends TileMapLayer

func _ready() -> void:
	SignalMan.emit_signal("ChangedLevel") # since its in every level, it will be always set to it when a scene changes and is ready
