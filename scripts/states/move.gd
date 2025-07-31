# move.gh

class_name Move extends State

@export_range(0, 10, 0.01, "suffix:tiles/s") var speed = 1.0
@export var error_radius: float = 16.0

var tween: Tween

# func enter():
# 	tween = create_tween()
# 	for pos in fsm.path.slice(1):
# 		tween.tween_property(fsm, "global_position", pos, 1.0 / speed)

func update(delta: float):
	var dir = fsm.manager.map_to_global(fsm.path[0]) - fsm.global_position

	if fsm.path.size() > 1 and dir.length() <= error_radius:
		fsm.map_position = fsm.path.pop_front()
		dir = fsm.manager.map_to_global(fsm.path[0]) - fsm.global_position
	elif fsm.path.size() == 1 and dir.length() <= 1.0:
		finished.emit("idle", true)

	fsm.global_position += dir.normalized() * speed

# func exit():
# 	if fsm.path.size() > 0:
# 		fsm.manager.astar.set_point_solid(fsm.path[-1], false)
# 	fsm.manager.astar.set_point_solid(fsm.map_position, false)
