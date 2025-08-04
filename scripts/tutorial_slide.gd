class_name TutorialSlide extends Node

@export_multiline var text: String

@export var input_blocked: bool
@export var ui_blocked: bool
@export var drag_blocked: bool
@export var clear_selected: bool
@export var timeline_locked: bool

@export var follow: StateMachine
@export var pause: bool

@export var wait_for_click: bool

@export var move_camera: bool
@export var camera_target: Vector2
@export var zoom_target: float

@onready var manager = get_node("../../manager")

func _ready() -> void:
	if wait_for_click:
		manager.input_blocker_clicked.connect(next_slide)

func next_slide():
	if !manager.click_consumed and manager.current_slide == get_index():
		manager.next_slide()
		manager.click_consumed = true
