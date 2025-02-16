class_name RelaxedState
extends PlayerState

@export var turn_rate: float = 10
@export_category("Transition States")
@export var aiming_state: State

@onready var player_model = $"../../PlayerModel"

func process_state_physics(delta):
	# Rotate player model to look in movement direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir != Vector2.ZERO:
		var look_dir = atan2(-target.velocity.x, -target.velocity.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, look_dir, delta * turn_rate)

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon"):
		return aiming_state
	if Input.is_action_just_pressed("toggle_build_mode"):
		return %BuildState
