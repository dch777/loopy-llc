# sit.gd

class_name Sit extends State

@export_range(0, 10, 0.01, "suffix:tiles/s") var speed = 0.07
@export var anger_noises: Array[AudioStream] = []

var jumping: bool = false

func enter():
	if fsm.site.workers.size() == fsm.site.seats.size():
		fsm.site = null
		if randf() <= 0.5:
			GameAudio.play_audio_once(anger_noises[randi() % anger_noises.size()], 2.0)
		finished.emit("idle", true)
		return
	elif fsm.site.workers.has(fsm.seat_idx):
		fsm.seat_idx = fsm.site.get_empty_seat()

	fsm.site.workers[fsm.seat_idx] = fsm
	fsm.facing_up = fsm.site.facing_up
	fsm.facing_left = fsm.site.facing_left
	fsm.play_animation("jump")

func update(_delta: float):
	if !jumping:
		jumping = fsm.animation_player.frame == 1 and fsm.animation_player.animation.contains("jump")
		return

	var dir: Vector2 = fsm.site.seats[fsm.seat_idx].global_position - fsm.global_position
	fsm.global_position += speed * dir

	if dir.length() < 0.01:
		completed = true
		finished.emit("work", true)

func exit():
	if !completed and fsm.site != null:
		fsm.site.workers.erase(fsm.seat_idx)
		fsm.seat_idx = -1
		fsm.site = null
		fsm.seated = false
	else:
		fsm.seated = true
