# move.gd

class_name Move extends State

@export_range(0, 10, 0.01, "suffix:tiles/s") var speed = 1.0
@export var error_radius: float = 16.0

func enter():
	fsm.site = null
	if fsm.path.size() > 0:
		fsm.manager.astar.set_point_solid(fsm.path[-1])

func update(delta: float):
	var dir = fsm.manager.map_to_global(fsm.path[0]) - fsm.global_position

	if fsm.path.size() > 1 and dir.length() <= error_radius:
		fsm.map_position = fsm.path.pop_front()
		dir = fsm.manager.map_to_global(fsm.path[0]) - fsm.global_position
	elif fsm.path.size() == 1 and dir.length() <= 1.0:
		if fsm.site != null:
			finished.emit("sit", true)
		else:
			finished.emit("idle", true)

	fsm.global_position += dir.normalized() * speed

func exit():
	if fsm.path.size() > 0:
		fsm.manager.astar.set_point_solid(fsm.path[-1], false)
