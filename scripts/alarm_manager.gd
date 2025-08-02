extends Node2D

@onready var hour = 1

@onready var has_triggered = false
@onready var percent_chance_trigger = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_time = GameTime.get_time_left()
	
	if hour == 1 and current_time <= 210.0:
		try_trigger_alarm()
	elif hour == 2 and current_time <= 180:
		try_trigger_alarm()
	elif hour == 3 and current_time <= 150:
		try_trigger_alarm()
	elif hour == 4 and current_time <= 120:
		try_trigger_alarm()
	elif hour == 5 and current_time <= 90:
		try_trigger_alarm()
	elif hour == 6 and current_time <= 60:
		try_trigger_alarm()
	elif hour == 7 and current_time <= 30:
		try_trigger_alarm()

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
	GameAudio.play_audio_loop(load("res://assets/audio/alarm-loop-sound-effect-94369.mp3"))
	$"../AlarmLight".show()
	$"../AnimationPlayer".play("alarm")
	has_triggered = true
