# work.gd

class_name Work extends State

# func update(delta: float):
# 	fsm.manager.astar.set_point_solid(fsm.map_position)

func exit():
	fsm.site.worker = null
	fsm.site = null
	fsm.seated = false
