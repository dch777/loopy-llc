# idle.gd

class_name Idle extends State

func enter():
	fsm.play_animation("idle")
