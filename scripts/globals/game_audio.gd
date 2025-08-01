extends Node2D

func play_audio_once(stream: AudioStream) -> AudioStreamPlayer2D:
	var stream_player = AudioStreamPlayer2D.new()
	stream_player.stream = stream
	stream_player.finished.connect(auto_remove_audio.bind(stream_player))
	add_child(stream_player)
	stream_player.play()
	return stream_player

func play_audio_loop(stream: AudioStream) -> AudioStreamPlayer2D:
	var stream_player = AudioStreamPlayer2D.new()
	stream_player.stream = stream
	stream_player.finished.connect(auto_restart_audio.bind(stream_player))
	add_child(stream_player)
	stream_player.play()
	return stream_player

func stop_audio(stream_player: AudioStreamPlayer2D) -> void:
	stream_player.queue_free()

func auto_restart_audio(stream_player: AudioStreamPlayer2D) -> void:
	print(stream_player)
	stream_player.play()

func auto_remove_audio(stream_player: AudioStreamPlayer2D) -> void:
	stream_player.queue_free()
