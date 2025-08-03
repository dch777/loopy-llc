# state_machine.gd

class_name StateMachine extends Node2D

@export_group("State")
@export var entry_state: String
@export var navigate_state: String
@export var sit_state: String

@export_group("Worker")
@export var spawn_position: Vector2i
@export var line_material: ShaderMaterial = preload("res://assets/shaders/line.tres")
@export var select_material: ShaderMaterial = preload("res://assets/shaders/select.tres")

@onready var manager: Manager = get_parent()
@onready var sleep_particles: CPUParticles2D = $CPUParticles2D

@onready var animation_player = $AnimatedSprite2D
var line: Line2D

@onready var initial_look_direction = 1.0
@onready var look_direction = initial_look_direction

var states: Dictionary[String, State] = {}
var state_stack: Array[State] = []

@onready var exhaustion: float = 0.0
var control_locked: bool = false

var selected: bool
var path: Array
var map_position: Vector2i

var site: TaskSite
var seat_idx: int
var seated: bool = false

@onready var emotion: String = "default"
@onready var facing_up: bool = false
@onready var facing_left: bool = false

func _ready():
	for child in find_children("*", "State"):
		states.get_or_add(child.name, child)
		child.finished.connect(change_state)
		animation_player.animation_finished.connect(child.animation_finished)
		child.fsm = self

	state_stack.push_front(states[entry_state])
	state_stack[0].enter()

	$Area2D.input_event.connect(self.input_event)
	$Area2D.mouse_entered.connect(self.mouse_entered)
	$Area2D.mouse_exited.connect(self.mouse_exited)

	line = $Line2D
	line.set_material(line_material.duplicate())
	line.material.set_shader_parameter("width", line.width)

	set_material(select_material.duplicate())

	map_position = spawn_position
	global_position = get_node("../background").map_to_local(map_position)

func _process(delta: float):
	if GameTime.get_time_left() == 0:
		exhaustion = 0
	
	if state_stack.size() > 0:
		state_stack[0].update(delta)

	exhaustion = max(exhaustion, 0.0)

	material.set_shader_parameter("selected", float(selected))
	if selected and path.size() > 0:
		line.visible = true
		line.points = [Vector2(0, 0)] + path.map(manager.map_to_global).map(to_local)

		var line_length: float = 0.0
		for i in range(1, line.points.size()):
			line_length += (line.points[i] - line.points[i-1]).length()
		line.material.set_shader_parameter("length", line_length)
	else:
		line.visible = false

func _physics_process(delta: float):
	if state_stack.size() > 0:
		state_stack[0].physics_update(delta)

func push_state(next_state: String):
	state_stack.push_front(states[next_state])
	state_stack[0].enter()

func change_state(next_state: String, pop: bool):
	if pop:
		state_stack.pop_front().exit()
	else:
		state_stack[0].exit()

	if next_state != null and next_state in states.keys():
		state_stack.push_front(states[next_state])
	if state_stack.size() > 0:
		state_stack[0].enter()

func play_animation(name: StringName, custom_speed: float = 1.0, from_end: bool = false):
	var ud = "up" if facing_up else "down"
	var lr = "left" if facing_left else "right"
	animation_player.play("%s_%s_%s_%s" % [emotion, ud, lr, name], custom_speed, from_end)

func pause_animation():
	animation_player.pause()

func input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if !control_locked:
		manager.worker_input_event(self, event)

func mouse_entered():
	manager.object_mouse_entered(self)

func mouse_exited():
	manager.object_mouse_exited(self)
