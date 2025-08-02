# idle.gd

class_name Idle extends State

func update(delta: float):
	fsm.play_animation("idle")
