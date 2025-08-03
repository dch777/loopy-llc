extends Control

@onready var what_stat_am_i_on = 0

@onready var total_tasks = 0
@onready var tasks_complete = 0
@onready var money_earned = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer2/Label.text = "%s/%s" % [tasks_complete, total_tasks]
	$VBoxContainer2/Label2.text = str(money_earned)
	GameTime.total_money += money_earned
	$VBoxContainer2/Label3.text = str(GameTime.total_money)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	if what_stat_am_i_on == 0:
		$VBoxContainer/Label.show()
		$VBoxContainer2/Label.show()
		$Timer.start()
		what_stat_am_i_on += 1
	elif what_stat_am_i_on == 1:
		$VBoxContainer/Label2.show()
		$VBoxContainer2/Label2.show()
		$Timer.start()
		what_stat_am_i_on += 1
	elif what_stat_am_i_on == 2:
		$VBoxContainer/Label3.show()
		$VBoxContainer2/Label3.show()
		$Timer.start()
		what_stat_am_i_on += 1
	else:
		$Path2D/PathFollow2D/Button.disabled = false
		$Path2D/PathFollow2D/Button.show()
		$AnimationPlayer.play("spawn_button")


func _on_button_button_up() -> void:
	print(get_parent().get_parent().get_node("manager").next_day())
