extends ColorRect

signal closed()

func _on_audio_stream_player_finished() -> void:
	hide()
	closed.emit()
