# manager.gd

class_name Manager extends Node2D

@export var diagonal_mode: AStarGrid2D.DiagonalMode = AStarGrid2D.DiagonalMode.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES

@onready var astar = AStarGrid2D.new()
@onready var ground: TileMapLayer = $ground
@onready var props: TileMapLayer = $props

@onready var hover_shader: ShaderMaterial = preload("res://assets/shaders/hover.tres")

var hovered_objects: Dictionary[Node2D, Object]
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
		astar.set_point_solid(worker.map_position)
		workers.push_back(worker)

func _process(delta: float) -> void:
	var hovered_cell = ground.local_to_map(get_local_mouse_position())
	var hovered_cell_global_coords = map_to_global(hovered_cell)
	hover_shader.set_shader_parameter("highlighted_cell", hovered_cell_global_coords)

	if selected_workers.size() > 0 and hovered_objects.size() == 0:
		hover_shader.set_shader_parameter("active", 1.0)
	else:
		hover_shader.set_shader_parameter("active", 0.0)

	if Input.is_action_just_pressed("select") and !astar.is_point_solid(hovered_cell) and hovered_objects.size() == 0:
		for worker in selected_workers:
			var path = astar.get_id_path(worker.map_position, hovered_cell, true);
			if path.size() > 0:
				astar.set_point_solid(worker.map_position, false)
				if worker.path.size() > 0:
					astar.set_point_solid(worker.path[-1], false)
				astar.set_point_solid(path[-1])
				worker.navigate(path)

func map_to_global(vec: Vector2) -> Vector2:
	return to_global(ground.map_to_local(vec))

func select_worker(worker: StateMachine):
	selected_workers[worker] = null
	worker.selected = true

func deselect_worker(worker: StateMachine):
	selected_workers.erase(worker)
	worker.selected = false

func clear_selected_workers():
	for worker in selected_workers:
		worker.selected = false
	selected_workers.clear()

func worker_input_event(worker: StateMachine, event: InputEvent):
	if event.is_action("select") and event.pressed:
		if selected_workers.has(worker) and Input.is_action_pressed("multi"):
			deselect_worker(worker)
		elif selected_workers.has(worker):
			if selected_workers.size() > 1:
				clear_selected_workers()
				select_worker(worker)
			else:
				deselect_worker(worker)
		else:
			if !Input.is_action_pressed("multi"):
				clear_selected_workers()
			select_worker(worker)

func object_mouse_entered(object: Node2D):
	hovered_objects[object] = null

func object_mouse_exited(object: Node2D):
	hovered_objects.erase(object)
