extends VBoxContainer

@export var id: int = 1

func _process(_delta) -> void:
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("select"):
		get_parent().get_parent().select_hour(id)
