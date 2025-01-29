class_name StateMachine
extends Node

@export var default_state: State
@export var target: Node

var current_state: State

func _ready():
	for child in get_children():
		child.target = target
	current_state = default_state
	current_state.enter()

func _process(delta):
	current_state.process_state(delta)
	var next = current_state.check_transitions()
	if next != null:
		transition_to(next)

func _physics_process(delta):
	current_state.process_state_physics(delta)

func _unhandled_input(event):
	current_state.process_input(event)

func transition_to(next: State):
	current_state.exit()
	current_state = next
	current_state.enter()
