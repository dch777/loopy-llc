extends Node2D

var current_streams: Dictionary[AudioStream, Object] = {}

func _process(delta: float) -> void:
	if GameTime.get_time_left() == 0:
		for c in get_children():
			c.queue_free()
		current_streams = {}

func play_audio_once(stream: AudioStream, pitch: float = 1.0, volume: float = 1.0) -> AudioStreamPlayer2D:
	if current_streams.has(stream):
		return

	var stream_player = AudioStreamPlayer2D.new()
	stream_player.stream = stream
	stream_player.finished.connect(auto_remove_audio.bind(stream_player))
	stream_player.pitch_scale = pitch
	stream_player.volume_db = volume
	add_child(stream_player)
	stream_player.play()
	current_streams[stream] = null
	return stream_player

func play_audio_loop(stream: AudioStream, pitch: float = 1.0, volume: float = 1.0) -> AudioStreamPlayer2D:
	if current_streams.has(stream):
		return

	var stream_player = AudioStreamPlayer2D.new()
	stream_player.stream = stream
	stream_player.volume_db = volume
	stream_player.finished.connect(auto_restart_audio.bind(stream_player))
	stream_player.pitch_scale = pitch
	add_child(stream_player)
	stream_player.play()
	current_streams[stream] = null
	return stream_player

func stop_audio(stream_player: AudioStreamPlayer2D) -> void:
	if stream_player == null:
		return

	current_streams.erase(stream_player.stream)
	stream_player.queue_free()

func auto_restart_audio(stream_player: AudioStreamPlayer2D) -> void:
	stream_player.play()

func auto_remove_audio(stream_player: AudioStreamPlayer2D) -> void:
	stop_audio(stream_player)
