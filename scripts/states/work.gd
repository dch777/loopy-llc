# work.gd

class_name Work extends State

func enter():
	fsm.facing_up = fsm.site.facing_up
	fsm.facing_left = fsm.site.facing_left
	fsm.play_animation(fsm.site.animation)

func exit():
	fsm.site.worker = null
	fsm.site = null
	fsm.seated = false
