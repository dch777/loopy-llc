extends Resource

class_name OfficeTask

var hour: int
var is_complete: bool = false
var task_type: int
var contract: Contract

var task_icon : TextureRect

func _init(_hour: int, _task_type: int) -> void:
	hour = _hour
	task_type = _task_type
	
	task_icon = TextureRect.new()
	var icon_path = "res://assets/sprites/task-%s.tres" % _task_type
	task_icon.texture = load(icon_path)
	task_icon.custom_minimum_size = Vector2(32, 32)
	task_icon.material = load("res://assets/shaders/task_incomplete.tres")
	
func complete() -> void:
	task_icon.material = load("res://assets/shaders/task_complete.tres")
	is_complete = true

func reset() -> void:
	task_icon.material = load("res://assets/shaders/task_incomplete.tres")
	is_complete = false
