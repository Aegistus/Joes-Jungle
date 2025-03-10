extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_model = player.get_node("PlayerModel")
@onready var aim_state_machine = player.get_node("AimStateMachine") as StateMachine
@onready var aiming_state = player.get_node("AimStateMachine/AimingState")
@onready var accuracy_indicator_left = $AccuracyIndicators/AccuracyIndicatorLeft as Node3D
@onready var accuracy_indicator_right = $AccuracyIndicators/AccuracyIndicatorRight as Node3D

const ACCURACY_DISTANCE_MAX = 3.0

func _process(delta):
	if aim_state_machine.current_state is AimingState:
		if aim_state_machine.current_state.intersection != null:
			position = aim_state_machine.current_state.intersection.position
			rotation = player_model.rotation
			visible = true
			if player.gun != null:
				var distance = ACCURACY_DISTANCE_MAX - ((player.gun.current_accuracy / 100.0) * ACCURACY_DISTANCE_MAX)
				accuracy_indicator_left.position.x = distance
				accuracy_indicator_right.position.x = -distance
	else:
		visible = false
