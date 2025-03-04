extends Node3D

@onready var player = get_tree().get_first_node_in_group("player") as Player
@onready var player_model = player.get_node("PlayerModel")
@onready var aim_state_machine = player.get_node("AimStateMachine") as StateMachine
@onready var aiming_state = player.get_node("AimStateMachine/AimingState")
@onready var accuracy_indicator_left = $AccuracyIndicators/AccuracyIndicatorLeft as Node3D
@onready var accuracy_indicator_right = $AccuracyIndicators/AccuracyIndicatorRight as Node3D

var aim_move_speed := 1.0
var mouse_delta : Vector2

const ACCURACY_DISTANCE_MAX = 3.0

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative

func _process(delta):
	if aim_state_machine.current_state is AimingState:
		var mouse_delta_3D = Vector3(mouse_delta.y, 0, -mouse_delta.x)
		mouse_delta_3D *= delta * aim_move_speed
		mouse_delta_3D *= player.directional_reference.basis
		global_position += mouse_delta_3D
		rotation = player_model.rotation
		visible = true
		if player.gun != null:
			var distance = ACCURACY_DISTANCE_MAX - ((player.gun.current_accuracy / 100.0) * ACCURACY_DISTANCE_MAX)
			accuracy_indicator_left.position.x = distance
			accuracy_indicator_right.position.x = -distance
		mouse_delta = Vector2.ZERO
		global_position += Vector3(player.velocity.x, 0, player.velocity.z) * delta
	else:
		visible = false
		global_position = player.global_position
