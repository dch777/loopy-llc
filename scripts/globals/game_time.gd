extends Node2D

var pause_lock: bool = false
var _temp_scale: float = 1.0

func start_game_time() -> void:
	$Timer.start()

func get_wait_time() -> float:
	return $Timer.wait_time

func get_time_left() -> float:
	return $Timer.time_left

func menu_pause():
	_temp_scale = Engine.time_scale
	GameTime.pause_lock = true
	Engine.time_scale = 0.01

func menu_restore():
	Engine.time_scale = _temp_scale
	GameTime.pause_lock = false

func toggle_pause():
	if Engine.time_scale == 1.0:
		Engine.time_scale = 0.01
	elif !pause_lock:
		Engine.time_scale = 1.0
