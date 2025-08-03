extends Node2D

@onready var car_crash_sound = preload("res://assets/audio/car-crash-sound-effect-376874.mp3")

func drive() -> void:
	var speed_multiplier = randf_range(1, 3)
	$AnimationPlayer.speed_scale = speed_multiplier
	$AnimationPlayer.play("drive")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var wait_time = randi_range(3, 15)
	$Timer.wait_time = wait_time
	$Timer.start()

func _on_timer_timeout() -> void:
	drive()


func _on_car_area_entered(area: Area2D) -> void:
	GameAudio.play_audio_once(car_crash_sound, 1.0, -5.0)
	area.get_parent().get_parent().hovered_objects.erase(area.get_parent())
	area.get_parent().get_parent().selected_workers.erase(area.get_parent())
	area.get_parent().get_parent().workers.erase(area.get_parent())
	area.get_parent().queue_free()
