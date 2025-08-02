# work.gd

class_name Work extends State

@onready var sound_timer = 0.0

func enter():
	fsm.facing_up = fsm.site.facing_up
	fsm.facing_left = fsm.site.facing_left
	fsm.play_animation(fsm.site.animation)

func update(delta: float):
	sound_timer += delta

	if fsm.site.sound != null and sound_timer >= fsm.site.sound_cooldown:
		if randf() <= fsm.site.sound_probability:
			GameAudio.play_audio_once(fsm.site.sound)
		sound_timer = 0.0

func exit():
	fsm.site.worker = null
	fsm.site = null
	fsm.seated = false
