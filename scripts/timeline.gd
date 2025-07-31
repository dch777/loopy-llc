extends Control

@onready var task_icon_0 = load("res://assets/sprites/task-0.tres")
@onready var task_icon_1 = load("res://assets/sprites/task-1.tres")
@onready var task_icon_2 = load("res://assets/sprites/task-2.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var schedule = {
		#1: [0],
		#2: [1],
		#3: [],
		#4: [],
		#5: [2],
		#6: [],
		#7: [],
		#8: [0, 1, 2]
	#}
	#add_tasks(schedule)
	pass # Replace with function body.

func add_tasks(schedule: Dictionary) -> void:
	for i in range(1, 9):
		for j in schedule[i]:
			var icon = TextureRect.new()
			if j == 0:
				icon.texture = task_icon_0
			elif j == 1:
				icon.texture = task_icon_1
			elif j == 2:
				icon.texture = task_icon_2
			var vbox_path = "Line2D/Hour%s/VBoxContainer" % i
			get_node(vbox_path).add_child(icon)
