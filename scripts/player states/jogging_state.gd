class_name JoggingState
extends PlayerState

@export var run_speed: float = 100
@export var animation_player: AnimationPlayer
@export var directional_reference: Node3D
@export var aim_state_machine: StateMachine

@export_category("Transition States")
@export var idle_state: State
@export var walking_state: State
@onready var reloading_state = $"../ReloadingState"
@onready var equipping_state = $"../EquippingState"
@onready var round_reload_loop_state = %RoundReloadLoopState
@onready var player_model = $"../../PlayerModel"

func enter():
	super()
	controlled_player.current_animation_tree.active = false

func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		target.velocity.x = direction.x * run_speed * delta * controlled_player.move_speed_multiplier
		target.velocity.z = direction.z * run_speed * delta * controlled_player.move_speed_multiplier
	target.move_and_slide()
	# Set animations
	animation_player.play(controlled_player.current_relaxed_jog_anim)

func check_transitions():
	if Input.is_action_just_pressed("reload"):
		if controlled_player.gun.ammo is SingleLoadAmmo:
			return round_reload_loop_state
		else:
			return reloading_state
	if aim_state_machine.current_state is AimingState:
		return walking_state
	if Input.is_action_just_pressed("equip_primary"):
		equipping_state.weapon_index = 0
		return equipping_state
	if Input.is_action_just_pressed("equip_secondary"):
		equipping_state.weapon_index = 1
		return equipping_state
	if Input.is_action_just_pressed("toggle_build_mode"):
		equipping_state.weapon_index = 2
		return equipping_state
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input.length() == 0:
		return idle_state
	else:
		return null
