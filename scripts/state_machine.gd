# state_machine.gd

class_name StateMachine extends Node2D

@export_group("State")
@export var entry_state: String
@export var navigate_state: String

@export_group("Worker")
@export var spawn_position: Vector2i

@onready var manager: Manager = get_parent()

@onready var animation_player = $AnimationPlayer
@onready var anim_speed = 1.0
@onready var initial_look_direction = 1.0
@onready var look_direction = initial_look_direction

var states: Dictionary[String, State] = {}
var state_stack: Array[State] = []

var max_energy: int
var modifiers: Array[int]

var selected: bool
var path: Array
var map_position: Vector2i

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

	map_position = spawn_position
	global_position = get_node("../ground").map_to_local(map_position)
	print(get_node("../ground").map_to_local(map_position))

func _process(delta: float):
	animation_player.advance(delta * anim_speed)
	if state_stack.size() > 0:
		state_stack[0].update(delta)

	$JustBlack.visible = selected

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

func navigate(path: Array):
	self.path = path
	change_state(navigate_state, true)

func input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	manager.worker_input_event(self, event)

func mouse_entered():
	manager.object_mouse_entered(self)

func mouse_exited():
	manager.object_mouse_exited(self)
