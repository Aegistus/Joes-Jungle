extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var aim_state_machine = player.get_node("AimStateMachine")
@onready var aiming_state = player.get_node("AimStateMachine/AimingState")

func _process(delta):
	if aim_state_machine.current_state is AimingState:
		if aiming_state.intersection != null:
			position = aiming_state.intersection.position
			visible = true
	else:
		visible = false
