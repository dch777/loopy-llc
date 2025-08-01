# sit.gd

class_name Sit extends State

@export_range(0, 10, 0.01, "suffix:tiles/s") var speed = 0.1

func enter():
	if fsm.site.worker != null:
		fsm.site = null
		finished.emit("idle", true)
	else:
		fsm.site.worker = fsm

func update(_delta: float):
	fsm.global_position += speed * (fsm.site.seat.global_position - fsm.global_position)

	if (fsm.global_position - fsm.site.seat.global_position).length() < 0.1:
		completed = true
		finished.emit("work", true)

func exit():
	fsm.seated = completed
