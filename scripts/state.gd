# state.gd

class_name State extends Node2D

var fsm: StateMachine
var completed: bool

signal finished(next_state: String, pop: bool)

func enter():
	return

func exit():
	return

func update(delta: float):
	return

func physics_update(delta: float):
	return

func animation_finished():
	return
