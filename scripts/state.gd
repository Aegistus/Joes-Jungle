class_name State
extends Node
## Base class for state machine states.

var target: Node

signal on_state_changed()

func enter():
	print("Entering: " + name)

func exit():
	pass

func process_input(event: InputEvent):
	pass

func process_state(delta: float):
	pass

func process_state_physics(delta: float):
	pass

func check_transitions() -> State:
	return null
