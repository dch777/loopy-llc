# task_site.gd

class_name TaskSite extends Node2D

@export var seats: Array[Area2D]
@export var target_offsets: Array[Vector2i]
@export var facing_up: bool = false
@export var facing_left: bool = false
@export var time_to_complete = 100
'''
	-2 - hr
	-1 - firealarm
	0 - desk
	1 - meeting
	2 - phone call
'''
@export var task_type: int
@export var should_be_workable: bool = true
var workable: bool = should_be_workable

@export var animation: String = "idle"
@export var sound: AudioStream

@export var sound_cooldown: float = 10.0
@export_range(0.0, 1.0) var sound_probability: float = 0.1

var map_position: Vector2i = Vector2(0, 0)

@onready var manager: Manager = get_parent()
var workers: Dictionary[int, StateMachine] = {}

var completion: float = 0.0
@export_range(-1.0, 1.0, 0.001, "suffix:%/s") var exhaustion_rate: float = 0.01

var time_accum = 0.0

signal finished_task(task_type: int)

func _process(delta: float) -> void:
	if !workable or GameTime.alarm:
		return

	var sleeping: bool = false
	for worker in workers.values():
		if worker.exhaustion > 0.9:
			sleeping = true

	if workers.size() != 0 and workers.size() == seats.size() and !sleeping: #TODO add logic that doesn't allow workers to finish tasks if they're too tired
		time_accum += delta
		if time_accum >= 1.0:
			working()
			time_accum = 0.0
	else:
		time_accum += delta
		if time_accum >= 1.0:
			not_working()
			time_accum = 0.0

	if GameTime.get_time_left() == 0:
		workable = false
	else:
		workable = should_be_workable


func _ready() -> void:
	workable = should_be_workable
	
	if workable:
		$TextureProgressBar.max_value = time_to_complete
		
	global_position = get_node("../background").map_to_local(map_position)

	for i in range(seats.size()):
		seats[i].input_event.connect(self.input_event.bind(i))
		seats[i].mouse_entered.connect(self.mouse_entered)
		seats[i].mouse_exited.connect(self.mouse_exited)

func get_empty_seat():
	for i in range(seats.size()):
		if !workers.has(i):
			return i

func input_event(_viewport: Node, event: InputEvent, _shape_idx: int, seat_idx: int):
	manager.site_input_event(self, event, seat_idx)

func mouse_entered():
	manager.object_mouse_entered(self)

func mouse_exited():
	manager.object_mouse_exited(self)
	
func working():
	if $TextureProgressBar.value == $TextureProgressBar.max_value:	# finished task!
		emit_signal("finished_task", task_type)
		$TextureProgressBar.value = 0
		return
		
	$TextureProgressBar.show()
	$TextureProgressBar.value += 1

func not_working():
	if $TextureProgressBar.value == 0:
		$TextureProgressBar.hide()
		return
	$TextureProgressBar.value -= 1
