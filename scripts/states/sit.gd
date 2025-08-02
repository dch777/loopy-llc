# sit.gd

class_name Sit extends State

@export_range(0, 10, 0.01, "suffix:tiles/s") var speed = 0.07
@export var anger_noises: Array[AudioStream] = []

var jumping: bool = false

func enter():
	if fsm.site.worker != null:
		fsm.site = null
		if randf() <= 0.5:
			GameAudio.play_audio_once(anger_noises[randi() % anger_noises.size()], 2.0)
		finished.emit("idle", true)
	else:
		fsm.site.worker = fsm
		fsm.facing_up = fsm.site.facing_up
		fsm.facing_left = fsm.site.facing_left
		fsm.play_animation("jump")

func update(_delta: float):
	if !jumping:
		jumping = fsm.animation_player.frame == 1 and fsm.animation_player.animation.contains("jump")
		return

	fsm.global_position += speed * (fsm.site.seat.global_position - fsm.global_position)

	if (fsm.global_position - fsm.site.seat.global_position).length() < 0.1:
		completed = true
		finished.emit("work", true)

func exit():
	fsm.seated = completed
	if !completed and fsm.site != null:
		fsm.site.worker = null
		fsm.site = null
		fsm.seated = false
