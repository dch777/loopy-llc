# manager.gd

class_name Manager extends Node2D

@export var diagonal_mode: AStarGrid2D.DiagonalMode = AStarGrid2D.DiagonalMode.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES

@onready var astar = AStarGrid2D.new()
@onready var ground: TileMapLayer = $ground
@onready var props: TileMapLayer = $props

@onready var hover_shader: ShaderMaterial = preload("res://assets/shaders/hover.tres")

var object_selected: bool
var selected_workers: Dictionary[StateMachine, Object]
var workers: Array[StateMachine]

func _ready() -> void:
	astar.set_diagonal_mode(diagonal_mode)
	astar.set_region(ground.get_used_rect())
	astar.update()

	for cell in props.get_used_cells():
		astar.set_point_solid(cell)

	for x in range(astar.region.position.x, astar.region.end.x):
		for y in range(astar.region.position.y, astar.region.end.y):
			var cell = Vector2(x, y)
			if ground.get_cell_source_id(cell) == -1:
				astar.set_point_solid(cell)

	for worker in find_children("*", "StateMachine"):
		workers.push_back(worker)
		astar.set_point_solid(worker.map_position)

func _process(delta: float) -> void:
	var hovered_cell = ground.local_to_map(get_local_mouse_position())
	var hovered_cell_global_coords = map_to_global(hovered_cell)
	hover_shader.set_shader_parameter("highlighted_cell", hovered_cell_global_coords)

	if selected_workers.size() > 0 and !object_selected:
		hover_shader.set_shader_parameter("active", 1.0)
	else:
		hover_shader.set_shader_parameter("active", 0.0)

	if Input.is_action_just_pressed("select") and selected_workers.size() > 0 and \
	   !astar.is_point_solid(hovered_cell) and !object_selected:
		var worker = selected_workers.keys()[0]
		var path = astar.get_id_path(worker.map_position, hovered_cell);
		if path.size() > 0:
			worker.navigate(path)

func map_to_global(vec: Vector2) -> Vector2:
	return to_global(ground.map_to_local(vec))

func worker_input_event(worker: StateMachine, event: InputEvent):
	if event.is_action("select") and event.pressed:
		if selected_workers.has(worker):
			selected_workers.erase(worker)
		else:
			selected_workers[worker] = null
		print(selected_workers)

func object_mouse_entered():
	object_selected = true

func object_mouse_exited():
	object_selected = false
