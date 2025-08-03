extends Node2D

@onready var hour = 1

@onready var has_triggered = false
@onready var percent_chance_trigger = 0.1

@onready var alarm = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time = GameTime.get_time_left()
	
	if GameTime.get_time_left() == 0:
		has_triggered = false
		percent_chance_trigger = 0.1
		alarm = null
		hour = 1
		$"../AlarmLight".hide()
		$"../AnimationPlayer".stop()
		return
	
	if hour == 1 and current_time <= 420.0:
		try_trigger_alarm()
	elif hour == 2 and current_time <= 360:
		try_trigger_alarm()
	elif hour == 3 and current_time <= 300:
		try_trigger_alarm()
	elif hour == 4 and current_time <= 240:
		try_trigger_alarm()
	elif hour == 5 and current_time <= 180:
		try_trigger_alarm()
	elif hour == 6 and current_time <= 120:
		try_trigger_alarm()
	elif hour == 7 and current_time <= 60:
		try_trigger_alarm()
	
	GameTime.alarm = get_parent().workable

func try_trigger_alarm() -> void:
	if has_triggered:
		return
		
	var roll = randf_range(0, 1)
	if roll <= percent_chance_trigger:
		start_alarm()
	percent_chance_trigger += 0.05
	hour += 1

func start_alarm() -> void:
	$"../Timer".start()
	alarm = GameAudio.play_audio_loop(load("res://assets/audio/alarm-loop-sound-effect-94369.mp3"))
	$"../AlarmLight".show()
	$"../AnimationPlayer".play("alarm")
	get_parent().workable = true
	#get_parent().seats.append($"../Area2D")
	#get_parent().target_offsets.append(Vector2i(1, 0))
	has_triggered = true


func _on_fire_alarm_finished_task(task_type: int) -> void:
	get_parent().workable = false
	$"../AlarmLight".hide()
	$"../AnimationPlayer".stop()
	GameAudio.stop_audio(alarm)
