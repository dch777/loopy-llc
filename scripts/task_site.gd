# task_site.gd

class_name TaskSite extends Node2D

@export var map_position: Vector2i = Vector2(0, 0)

@onready var manager: Manager = get_parent()
@onready var seat: Node2D = $seat
var worker: StateMachine = null

func _ready() -> void:
	global_position = get_node("../ground").map_to_local(map_position)

	$Area2D.input_event.connect(self.input_event)
	$Area2D.mouse_entered.connect(self.mouse_entered)
	$Area2D.mouse_exited.connect(self.mouse_exited)

	seat.visible = false

func input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	manager.site_input_event(self, event)

func mouse_entered():
	manager.object_mouse_entered(self)

func mouse_exited():
	manager.object_mouse_exited(self)
