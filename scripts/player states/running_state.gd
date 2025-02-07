class_name JoggingState
extends PlayerState

@export var run_speed: float = 100
@export var animation_player: AnimationPlayer
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var aim_state_machine: StateMachine

@export_category("Transition States")
@export var idle_state: State
@export var walking_state: State

@onready var anim_tree = $"../../PlayerModel/Model/AnimTree"

func enter():
	super()
	anim_tree["parameters/conditions/Idle"] = false
	anim_tree["parameters/conditions/Jog"] = true
	anim_tree["parameters/conditions/Walk"] = false

func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		target.velocity.x = direction.x * run_speed * delta
		target.velocity.z = direction.z * run_speed * delta
	target.	move_and_slide()
	# Set animations
	animation_player.play(controlled_player.current_relaxed_jog_anim)

func check_transitions():
	if aim_state_machine.current_state is AimingState:
		return walking_state
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input.length() == 0:
		return idle_state
	else:
		return null
