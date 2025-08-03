extends Node2D

@onready var door_close_sound = preload("res://assets/audio/close-door-382723.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	$Sprite2D.hide()


func _on_area_2d_area_exited(area: Area2D) -> void:
	GameAudio.play_audio_once(door_close_sound, 1.0, -3.0)
	$Sprite2D.show()
