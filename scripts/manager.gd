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

@onready var select_timer: float = 0.0
var select_origin: Vector2
var select_rect: Rect2

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

func _process(delta: float) -> void:
	var hovered_cell = ground.local_to_map(get_local_mouse_position())
	var hovered_cell_global_coords = map_to_global(hovered_cell)
	hover_shader.set_shader_parameter("highlighted_cell", hovered_cell_global_coords)

	if select_timer < 0.5 and select_rect.size.length() <= 32 and selected_workers.size() > 0 and hovered_objects.size() == 0 and astar.is_in_boundsv(hovered_cell) and !astar.is_point_solid(hovered_cell):
		hover_shader.set_shader_parameter("active", 1.0)
	else:
		hover_shader.set_shader_parameter("active", 0.0)

	if Input.is_action_just_released("select") and select_timer < 0.5 and select_rect.size.length() < 32 and !astar.is_point_solid(hovered_cell) and hovered_objects.size() == 0:
		for worker in selected_workers:
			navigate(worker, hovered_cell)

	if select_timer > 0.0:
		select_rect = Rect2(select_origin, get_local_mouse_position() - select_origin).abs()
		queue_redraw()

	if Input.is_action_just_pressed("select"):
		select_origin = get_local_mouse_position()
	if Input.is_action_pressed("select"):
		select_timer += delta
	else:
		select_timer = 0.0
		select_rect = Rect2()

func _draw():
	if select_timer > 0.0 and (select_timer > 0.5 or select_rect.size.length() > 32):
		draw_rect(select_rect, Color(0.7, 0.7, 0.7, 0.5))
		for worker in find_children("*", "StateMachine"):
			if select_rect.has_point(worker.position):
				select_worker(worker)
			elif !Input.is_action_pressed("multi"):
				deselect_worker(worker)

func navigate(worker: StateMachine, dest: Vector2i, pop: bool = true) -> void:
	var path = astar.get_id_path(worker.map_position, dest, true);
	if path.size() > 0:
		if worker.path.size() > 0:
			astar.set_point_solid(worker.path[-1], false)
		worker.path = path
		worker.change_state(worker.navigate_state, pop)

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

func site_input_event(site: TaskSite, event: InputEvent):
	if event.is_action("select") and event.pressed and site.worker == null and selected_workers.size() > 0 and hovered_objects.size() == 1:
		for worker in selected_workers:
			navigate(worker, site.map_position)
			worker.site = site

func object_mouse_entered(object: Node2D):
	hovered_objects[object] = null

func object_mouse_exited(object: Node2D):
	hovered_objects.erase(object)
