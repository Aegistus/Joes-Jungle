class_name AimingState
extends PlayerState

@export var resting_state: State

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon"):
		return resting_state
