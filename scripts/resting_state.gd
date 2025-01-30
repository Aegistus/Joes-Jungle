class_name RestingState
extends PlayerState

@export var player_model: Node3D
@export var turn_rate: float = 10
@export_group("Transition States")
@export var aiming_state: State

func process_state_physics(delta):
	# Rotate player model to look in movement direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir != Vector2.ZERO:
		var look_dir = atan2(-target.velocity.x, -target.velocity.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, look_dir, delta * turn_rate)

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon"):
		return aiming_state
