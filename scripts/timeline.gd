extends Control

@onready var task_icon_0 = preload("res://assets/sprites/task-0.tres")
@onready var task_icon_1 = preload("res://assets/sprites/task-1.tres")
@onready var task_icon_2 = preload("res://assets/sprites/task-2.tres")

@onready var task_complete_audio = preload("res://assets/audio/classic-game-action-positive-30-224562.mp3")

@onready var show_tasks = false
@onready var num_tasks_per_hour = {
	1: 0,
	2: 0,
	3: 0,
	4: 0,
	5: 0,
	6: 0,
	7: 0,
	8: 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HourMarker/AnimatedSprite2D.play("default")
	
	#var schedule = []
	#for i in range(1,9):
		#for k in range(0,2):
			#for j in range(0,2):
				#schedule.append(OfficeTask.new(i, j))
	#add_tasks(schedule)
	
	GameTime.start_game_time()

func _process(delta: float) -> void:
	# Move hour marker across
	var t = 1.0 - (GameTime.get_time_left() / GameTime.get_wait_time())
	t = clamp(t, 0, 1)
	$HourMarker.position.x = lerp($Line2D.points[0].x, $Line2D.points[1].x, t)
	
func add_task(task: OfficeTask) -> void:
	var vbox_path = "Line2D/Sections/Hour%s/VBoxContainer%s" % [task.hour, num_tasks_per_hour[task.hour] % 3 + 1]
	get_node(vbox_path).add_child(task.task_icon)
	num_tasks_per_hour[task.hour] += 1
	
func add_tasks(schedule: Array) -> void:
	for task in schedule:
		add_task(task)

func complete_task(task: OfficeTask) -> void:
	task.complete()

func _on_dropdown_button_up() -> void:
	if show_tasks:
		$Line2D/Sections.hide()
		$FullCover.hide()
		$Dropdown.texture_normal = load("res://assets/sprites/drop.tres")
	else:
		$Line2D/Sections.show()
		$FullCover.show()
		$Dropdown.texture_normal = load("res://assets/sprites/down.tres")
	show_tasks = not show_tasks
