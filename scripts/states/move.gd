# move.gd

class_name Move extends State

@export_range(0, 10, 0.01, "suffix:t/s") var speed: float = 1.0
@export_range(0, 10, 0.01, "suffix:t/s") var tired_speed: float = 0.5
@export var error_radius: float = 16.0
@export_range(0, 1.0, 0.01, "suffix:%/t") var exhaustion_rate: float = 0.01

func enter():
	fsm.play_animation("walk")

	fsm.site = null
	if fsm.path.size() > 0:
		fsm.manager.astar.set_point_solid(fsm.path[-1])

func update(delta: float):
	var dir = fsm.manager.map_to_global(fsm.path[0]) - fsm.global_position

	fsm.facing_up = dir.y < 0
	fsm.facing_left = dir.x < 0
	fsm.play_animation("walk")

	if fsm.path.size() > 1 and dir.length() <= error_radius:
		fsm.map_position = fsm.path.pop_front()
		fsm.exhaustion += exhaustion_rate
		dir = fsm.manager.map_to_global(fsm.path[0]) - fsm.global_position
	elif fsm.path.size() == 1 and dir.length() <= 1.0:
		completed = true
		if fsm.site != null:
			finished.emit("sit", true)
		else:
			finished.emit("idle", true)

	if fsm.exhaustion > 0.9 and !fsm.selected:
		finished.emit("sleep", false)
	elif fsm.exhaustion > 0.5:
		fsm.emotion = "tired"
		fsm.global_position += dir.normalized() * tired_speed
	else:
		fsm.global_position += dir.normalized() * speed

func exit():
	if completed and fsm.path.size() > 0:
		fsm.manager.astar.set_point_solid(fsm.path[-1], false)
		fsm.path.pop_front()
