# contract.gd

class_name Contract extends Resource

signal contract_completed(contract: Contract)

@export var contract_name: String
@export var task_ids: Array[int]
@export var cost: int
@export var num_worker_rewarded: int
@export var cash_rewarded: int

var tasks: Array[OfficeTask]

func _init(_contract_name: String = "", _task_ids: Array[int] = [], _cost: int = 0, _num_worker_rewarded: int = 0, _cash_rewarded: int = 0):
	self.contract_name = _contract_name
	self.task_ids = _task_ids
	self.cost = _cost
	self.num_worker_rewarded = _num_worker_rewarded
	self.cash_rewarded = _cash_rewarded

func check_completion():
	print("checking completion")
	print(tasks)
	for task in tasks:
		if !task.is_complete:
			return

	contract_completed.emit(self)
