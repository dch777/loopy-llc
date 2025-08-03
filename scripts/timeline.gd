extends Control

@export var manager: Manager

@onready var task_icon_0 = preload("res://assets/sprites/task-0.tres")
@onready var task_icon_1 = preload("res://assets/sprites/task-1.tres")
@onready var task_icon_2 = preload("res://assets/sprites/task-2.tres")

@onready var task_complete_audio = preload("res://assets/audio/classic-game-action-positive-30-224562.mp3")

@onready var show_tasks = false
@onready var schedule = []
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

@onready var current_hour = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(1,9):
		for k in range(0,3):
			for j in range(0,3):
				add_task(OfficeTask.new(i, j))
	
	$HourMarker/AnimatedSprite2D.play("default")
	
	$FullCover.mouse_entered.connect(manager.object_mouse_entered.bind(self))
	$LineCover.mouse_entered.connect(manager.object_mouse_entered.bind(self))
	$FullCover.mouse_exited.connect(manager.object_mouse_exited.bind(self))
	$LineCover.mouse_exited.connect(manager.object_mouse_exited.bind(self))

	GameTime.start_game_time()
	GameAudio.play_audio_loop(load("res://assets/audio/Beach House.ogg"))

func _process(delta: float) -> void:
	# Move hour marker across
	var t = 1.0 - (GameTime.get_time_left() / GameTime.get_wait_time())
	t = clamp(t, 0, 1)
	$HourMarker.position.x = lerp($Line2D.points[0].x, $Line2D.points[1].x, t)
	
	var current_time = GameTime.get_time_left()
	if current_hour == 1 and current_time <= 420.0:
		current_hour += 1
	elif current_hour == 2 and current_time <= 360:
		current_hour += 1
	elif current_hour == 3 and current_time <= 300:
		current_hour += 1
	elif current_hour == 4 and current_time <= 240:
		current_hour += 1
	elif current_hour == 5 and current_time <= 180:
		current_hour += 1
	elif current_hour == 6 and current_time <= 120:
		current_hour += 1
	elif current_hour == 7 and current_time <= 60:
		current_hour += 1

func _on_finished_task(task_type: int):
	print(task_type)
	for task in schedule:
		if task.hour == current_hour and task.task_type == task_type and not task.is_complete:
			complete_task(task)
			return

func add_task(task: OfficeTask) -> void:
	var vbox_path = "Line2D/Sections/Hour%s/VBoxContainer%s" % [task.hour, num_tasks_per_hour[task.hour] % 3 + 1]
	get_node(vbox_path).add_child(task.task_icon)
	schedule.append(task)
	num_tasks_per_hour[task.hour] += 1
	
#func add_tasks(schedule: Array) -> void:
	#for task in schedule:
		#add_task(task)

func complete_task(task: OfficeTask) -> void:
	task.complete()

func _on_line_cover_gui_input(event:InputEvent) -> void:
	if !show_tasks and event.is_action("select") and event.pressed:
		manager.clear_selected_workers()
		$Line2D/Sections.show()
		$FullCover.show()
		$LineCover.hide()
		show_tasks = true

func _on_full_cover_gui_input(event:InputEvent) -> void:
	if show_tasks and event.is_action("select") and event.pressed:
		$Line2D/Sections.hide()
		$FullCover.hide()
		$LineCover.show()
		show_tasks = false
