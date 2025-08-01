extends Control

@onready var task_icon_0 = preload("res://assets/sprites/task-0.tres")
@onready var task_icon_1 = preload("res://assets/sprites/task-1.tres")
@onready var task_icon_2 = preload("res://assets/sprites/task-2.tres")

@onready var task_complete_audio = preload("res://assets/audio/classic-game-action-positive-30-224562.mp3")

@onready var show_tasks = false

var schedule = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HourMarker/AnimatedSprite2D.play("default")
	
	for i in range(1,9):
		for j in range(0,3):
			schedule.append(OfficeTask.new(i, j))
	add_tasks(schedule)
	
	GameTime.start_game_time()

func _process(delta: float) -> void:
	if GameTime.get_time_left() <= 240.0 and not schedule[0].is_complete:
		complete_task(schedule[0])
	
	# Move hour marker across
	var t = 1.0 - (GameTime.get_time_left() / GameTime.get_wait_time())
	t = clamp(t, 0, 1)
	$HourMarker.position.x = lerp($Line2D.points[0].x, $Line2D.points[1].x, t)
	
func add_task(task: OfficeTask) -> void:
	var vbox_path = "Line2D/Sections/Hour%s/VBoxContainer" % task.hour
	get_node(vbox_path).add_child(task.task_icon)
	
func add_tasks(schedule: Array) -> void:
	for task in schedule:
		add_task(task)

func complete_task(task: OfficeTask) -> void:
	GameAudio.play_audio_loop(task_complete_audio)
	task.complete()


func _on_dropdown_button_up() -> void:
	if show_tasks:
		$Line2D/Sections.hide()
		$Dropdown.texture_normal = load("res://assets/sprites/drop.tres")
	else:
		$Line2D/Sections.show()
		$Dropdown.texture_normal = load("res://assets/sprites/down.tres")
	show_tasks = not show_tasks
