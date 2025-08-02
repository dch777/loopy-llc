extends Node2D

func start_game_time() -> void:
	$Timer.start()

func get_wait_time() -> float:
	return $Timer.wait_time

func get_time_left() -> float:
	return $Timer.time_left
