# idle.gd

class_name Idle extends State

func update(delta: float):
	fsm.play_animation("idle")
	
	if fsm.exhaustion > 0.9 and !fsm.selected:
		finished.emit("sleep", false)
	elif fsm.exhaustion > 0.5:
		fsm.emotion = "tired"
