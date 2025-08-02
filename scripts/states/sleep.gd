# sleep.gd

class_name Sleep extends State

@export_range(-1.0, 1.0, 0.01, "suffix:%/s") var recovery_rate: float = 0.01
@export_range(-1.0, 1.0, 0.01, "suffix:%/s") var wake_threshold: float = 0.5

func enter():
	fsm.emotion = "asleep"
	fsm.play_animation("idle")
	fsm.sleep_particles.emitting = true

func update(delta: float):
	# print(fsm.exhaustion)
	if fsm.site and fsm.site.exhaustion_rate < -recovery_rate:
		fsm.exhaustion += fsm.site.exhaustion_rate * delta
	else:
		fsm.exhaustion -= recovery_rate * delta
	
	if fsm.selected:
		fsm.emotion = "tired"
		finished.emit("", true)
	elif fsm.exhaustion < wake_threshold:
		finished.emit("", true)

func exit():
	fsm.emotion = "tired"
	fsm.sleep_particles.emitting = false
