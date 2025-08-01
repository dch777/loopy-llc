# camera.gd

extends Camera2D

@export var zoom_max: float = 3.0
@export var zoom_min: float = 0.5

@onready var zoom_target: float = zoom.x
var previous_position: Vector2

func _process(delta: float) -> void:
	var zoom_factor: float = 0.0

	if zoom_target <= zoom_max and Input.is_action_just_released("zoom in"):
		zoom_factor = 1.0
	if zoom_target >= zoom_min and Input.is_action_just_released("zoom out"):
		zoom_factor = -1.0

	zoom_target *= 1.2 ** zoom_factor
	zoom = lerp(zoom, Vector2(zoom_target, zoom_target), 0.1)

func _input(event: InputEvent) -> void:
	if event.is_action("drag") and event.pressed:
		previous_position = event.position

	if Input.is_action_pressed("drag") and event is InputEventMouseMotion:
		global_position -= (1.0 / zoom.x) * (event.position - previous_position)
		previous_position = event.position
