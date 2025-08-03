extends Node2D

var pause_lock: bool = false

var total_money: int = 0

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


func _on_timer_timeout() -> void:
	var end_day_scene = load("res://ui/end_day.tscn")
