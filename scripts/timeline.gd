extends Control

@export var manager: Manager

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
	
	var schedule = []
	for i in range(1,9):
		for k in range(0,2):
			for j in range(0,2):
				schedule.append(OfficeTask.new(i, j))
	add_tasks(schedule)
	
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
	
func add_task(task: OfficeTask) -> void:
	var vbox_path = "Line2D/Sections/Hour%s/VBoxContainer%s" % [task.hour, num_tasks_per_hour[task.hour] % 3 + 1]
	get_node(vbox_path).add_child(task.task_icon)
	num_tasks_per_hour[task.hour] += 1
	
func add_tasks(schedule: Array) -> void:
	for task in schedule:
		add_task(task)

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
