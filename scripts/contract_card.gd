# contract_card.gd

class_name ContractCard extends TextureRect

signal select_contract(contract_card: ContractCard)
signal contract_completed(contract_card: Contract)

@export var contract: Contract = Contract.new()

@onready var name_label: Label = $SubViewport/ColorRect/MarginContainer/VBoxContainer/NameLabel

@onready var cost_label: Label = $SubViewport/ColorRect/MarginContainer/VBoxContainer/CostLabel
@onready var cost_separator: HSeparator = $SubViewport/ColorRect/MarginContainer/VBoxContainer/CostSeparator

@onready var reward_label: Label = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardLabel
@onready var reward_separator: HSeparator = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardSeparator
@onready var reward_container: HBoxContainer = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardContainer

@onready var reward_cash: Label = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardContainer/CashLabel
@onready var reward_vseparator: VSeparator = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardContainer/VSeparator
@onready var reward_worker: TextureRect = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardContainer/WorkerRect
@onready var reward_xamount: Label = $SubViewport/ColorRect/MarginContainer/VBoxContainer/RewardContainer/XAmount

@onready var task_label: Label = $SubViewport/ColorRect/MarginContainer/VBoxContainer/TaskLabel
@onready var task_separator: HSeparator = $SubViewport/ColorRect/MarginContainer/VBoxContainer/TaskSeparator
@onready var task_container: HBoxContainer = $SubViewport/ColorRect/MarginContainer/VBoxContainer/TaskContainer

func _ready() -> void:
	populate()

func populate():
	for child in task_container.get_children():
		child.queue_free()

	name_label.text = contract.contract_name

	if contract.cost > 0:
		cost_label.text = "Cost: $%s" % contract.cost
		cost_label.visible = true
		cost_separator.visible = true
	else:
		cost_label.visible = false
		cost_separator.visible = false

	if contract.task_ids.size() > 0:
		task_label.visible = true
		task_separator.visible = true
		task_container.visible = true
	else:
		task_label.visible = false
		task_separator.visible = false
		task_container.visible = false

	for i in range(contract.task_ids.size()):
		var task_icon = TextureRect.new()
		var icon_path = "res://assets/sprites/task-%s.tres" % contract.task_ids[i]

		task_icon.texture = load(icon_path)
		task_icon.custom_minimum_size = Vector2(32, 32)
		task_icon.material = load("res://assets/shaders/icon.tres")

		task_container.add_child(task_icon)
		if i < contract.task_ids.size() - 1:
			task_container.add_child(VSeparator.new())

	if contract.num_worker_rewarded > 0 or contract.cash_rewarded > 0:
		reward_label.visible = true
		reward_separator.visible = true
		reward_container.visible = true
	else:
		reward_label.visible = false
		reward_separator.visible = false
		reward_container.visible = false

	if contract.num_worker_rewarded > 0:
		reward_xamount.text = "x%s" % contract.num_worker_rewarded
		reward_worker.visible = true
		reward_xamount.visible = true
	else:
		reward_worker.visible = false
		reward_xamount.visible = false

	if contract.cash_rewarded > 0:
		reward_cash.text = "$%s" % contract.cash_rewarded
		reward_cash.visible = true
	else:
		reward_cash.visible = false

	reward_vseparator.visible = contract.num_worker_rewarded > 0 and contract.cash_rewarded > 0

func _on_gui_input(event:InputEvent) -> void:
	if event.is_action("select") and event.pressed:
		select_contract.emit(self)

func check_completion():
	for task in contract.tasks:
		if !task.is_complete:
			return

	contract_completed.emit(self)
