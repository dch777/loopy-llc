extends Node2D

var pause_lock: bool = false

func start_game_time() -> void:
	$Timer.start()

func get_wait_time() -> float:
	return $Timer.wait_time

func get_time_left() -> float:
	return $Timer.time_left

func toggle_pause():
	if Engine.time_scale == 1.0:
		Engine.time_scale = 0.01
	elif !pause_lock:
		Engine.time_scale = 1.0
