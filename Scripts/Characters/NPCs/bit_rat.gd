extends Area2D

var colliding: int = 0


func _on_body_entered(_body: Node2D) -> void:
	colliding += 1
	hide_or_show_label()


func _on_audio_stream_player_finished() -> void:
	LevelMan.Can_quit_level = true
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), false)
	hide_or_show_label()


func _on_body_exited(_body: Node2D) -> void:
	colliding -= 1
	hide_or_show_label()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Interact") and not $AudioStreamPlayer.playing and colliding > 0:
		LevelMan.Can_quit_level = false
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), true)
		$AudioStreamPlayer.play()


func hide_or_show_label() -> void:
	if colliding > 0 and not $AudioStreamPlayer.playing:
		$Label.show()
	else:
		$Label.hide()
