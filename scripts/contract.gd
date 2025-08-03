# contract.gd

class_name Contract extends Resource

@export var contract_name: String
@export var tasks: Array[OfficeTask]
@export var cost: int
@export var num_worker_rewarded: int
@export var cash_rewarded: int

func _init(contract_name: String = "", tasks: Array[OfficeTask] = [], cost: int = 0, num_worker_rewarded: int = 0, cash_rewarded: int = 0):
	self.contract_name = contract_name
	self.tasks = tasks
	self.cost = cost
	self.num_worker_rewarded = num_worker_rewarded
	self.cash_rewarded = cash_rewarded
