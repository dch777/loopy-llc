# work.gd

class_name Work extends State

@onready var sound_timer = 0.0

func enter():
	fsm.facing_up = fsm.site.facing_up
	fsm.facing_left = fsm.site.facing_left

func update(delta: float):
	fsm.play_animation(fsm.site.animation)

	sound_timer += delta

	if fsm.site.sound != null and sound_timer >= fsm.site.sound_cooldown:
		if randf() <= fsm.site.sound_probability and GameTime.get_time_left() != 0:
			GameAudio.play_audio_once(fsm.site.sound)
		sound_timer = 0.0
	
	if fsm.site.workable or fsm.site.exhaustion_rate < 0.0:
		fsm.exhaustion += fsm.site.exhaustion_rate * delta

	if fsm.exhaustion > 0.9 and !fsm.selected:
		completed = true
		finished.emit("sleep", false)
	elif fsm.exhaustion > 0.7:
		fsm.emotion = "tired"
	else:
		fsm.emotion = "default"

func exit():
	if !completed and fsm.site != null:
		fsm.site.workers.erase(fsm.seat_idx)
		fsm.seat_idx = -1
		fsm.site = null
		fsm.seated = false
