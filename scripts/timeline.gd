extends Control

@export var manager: Manager
@export var contracts: Array[Contract]

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

@onready var timeline_lock = false
var selected_contract: Contract
var selected_card: ContractCard
var selected_hour: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HourMarker/AnimatedSprite2D.play("default")

	$FullCover.mouse_entered.connect(manager.object_mouse_entered.bind(self))
	$LineCover.mouse_entered.connect(manager.object_mouse_entered.bind(self))
	$FullCover.mouse_exited.connect(manager.object_mouse_exited.bind(self))
	$LineCover.mouse_exited.connect(manager.object_mouse_exited.bind(self))

	for contract_card in $NewContractCards.find_children("*", "ContractCard"):
		contract_card.select_contract.connect(select_contract)

	GameTime.start_game_time()

func _process(delta: float) -> void:
	# Move hour marker across
	var t = 1.0 - (GameTime.get_time_left() / GameTime.get_wait_time())
	t = clamp(t, 0, 1)
	$HourMarker.position.x = lerp($Line2D.points[0].x, $Line2D.points[1].x, t)

	if $NewContractCards.visible and selected_contract != null and selected_hour != -1:
		$NewContractCards/Confirm.color = Color("#5bb361")
		if $NewContractCards/Confirm.get_rect().has_point(get_local_mouse_position()) and Input.is_action_just_pressed("select"):
			confirm_contract()
	else:
		$NewContractCards/Confirm.color = Color("#9b9c82")
	
	var current_time = GameTime.get_time_left()
	if current_hour == 1 and current_time <= 210.0:
		current_hour += 1
	elif current_hour == 2 and current_time <= 180:
		current_hour += 1
	elif current_hour == 3 and current_time <= 150:
		current_hour += 1
	elif current_hour == 4 and current_time <= 120:
		current_hour += 1
	elif current_hour == 5 and current_time <= 90:
		current_hour += 1
	elif current_hour == 6 and current_time <= 60:
		current_hour += 1
	elif current_hour == 7 and current_time <= 30:
		current_hour += 1

func _on_finished_task(task_type: int):
	for task in schedule:
		if task.hour == current_hour and task.task_type == task_type and not task.is_complete:
			complete_task(task)
			return

func add_task(task: OfficeTask) -> void:
	var box_path = "FullCover/Hour%s/GridContainer" % task.hour
	get_node(box_path).add_child(task.task_icon)
	schedule.append(task)
	num_tasks_per_hour[task.hour] += 1

func preview_contract(contract: Contract, hour: int):
	if selected_contract == null or hour < 1:
		return

	for i in range(contract.task_ids.size()):
		var task_icon = TextureRect.new()
		var icon_path = "res://assets/sprites/task-%s.tres" % contract.task_ids[i]

		task_icon.texture = load(icon_path)
		task_icon.custom_minimum_size = Vector2(32, 32)
		task_icon.material = load("res://assets/shaders/task_incomplete.tres")

		var box_path = "FullCover/Hour%s/GridContainer" % (hour + i)
		get_node(box_path).add_child(task_icon)

func clear_preview(contract: Contract, hour: int):
	if selected_contract == null or hour < 1:
		return

	for i in range(contract.task_ids.size()):
		var box = get_node("FullCover/Hour%s/GridContainer" % (hour + i))
		box.remove_child(box.get_child(box.get_child_count() - 1))

func complete_task(task: OfficeTask) -> void:
	task.complete()

func open_contract_selection():
	for contract_card in $NewContractCards.find_children("*", "ContractCard"):
		contract_card.contract = contracts[randi() % contracts.size()]
		contract_card.populate()

	manager.clear_selected_workers()
	$NewContractCards.show()
	$FullCover.show()
	$LineCover.hide()

	show_tasks = true
	timeline_lock = true

	GameTime.menu_pause()

func close_contract_selection():
	$NewContractCards.hide()
	$FullCover.hide()
	$LineCover.show()

	show_tasks = false
	timeline_lock = false

	GameTime.menu_restore()
	
func select_hour(hour: int):
	if selected_contract != null and hour + selected_contract.task_ids.size() > 8:
		hour = 9 - selected_contract.task_ids.size()

	if hour != selected_hour:
		clear_preview(selected_contract, selected_hour)
		selected_hour = hour
		preview_contract(selected_contract, selected_hour)

func select_contract(contract_card: ContractCard):
	clear_preview(selected_contract, selected_hour)
	if selected_card != null:
		selected_card.scale = Vector2(0.15, 0.15)

	selected_hour = -1
	selected_contract = contract_card.contract
	selected_card = contract_card

	selected_card.scale = Vector2(0.16, 0.16)

func confirm_contract():
	clear_preview(selected_contract, selected_hour)
	for i in range(selected_contract.task_ids.size()):
		add_task(OfficeTask.new(selected_hour + i, selected_contract.task_ids[i]))

	selected_hour = -1
	selected_contract = null
	selected_card.scale = Vector2(0.15, 0.15)
	selected_card = null

	close_contract_selection()

func _on_line_cover_gui_input(event:InputEvent) -> void:
	if !show_tasks and event.is_action("select") and event.pressed:
		open_contract_selection()
		# manager.clear_selected_workers()
		# $FullCover.show()
		# $LineCover.hide()
		# show_tasks = true

		# GameTime.menu_pause()

func _on_full_cover_gui_input(event:InputEvent) -> void:
	if show_tasks and event.is_action("select") and event.pressed and !timeline_lock:
		$FullCover.hide()
		$LineCover.show()
		show_tasks = false

		GameTime.menu_restore()
