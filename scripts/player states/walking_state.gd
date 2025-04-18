class_name WalkingState
extends PlayerState

@export var movement_speed: float = 100
@export var animation_player: AnimationPlayer
@export var aim_state_machine: StateMachine
@export var rest_state: State
@export_category("Transition States")
@export var idle_state: State
@export var jogging_state: State
@onready var reloading_state = $"../ReloadingState"
@onready var equipping_state = $"../EquippingState"
@onready var player_model = $"../../PlayerModel"
@onready var round_reload_loop_state = %RoundReloadLoopState

func enter():
	super()
	controlled_player.current_animation_tree.active = true
	if controlled_player.primary_weapon != null:
		controlled_player.primary_weapon.ergonomics_multiplier = 1
	if controlled_player.secondary_weapon != null:
		controlled_player.secondary_weapon.ergonomics_multiplier = 1

func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (%ShakeableCamera.directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		target.velocity.x = direction.x * movement_speed * delta * controlled_player.move_speed_multiplier
		target.velocity.z = direction.z * movement_speed * delta * controlled_player.move_speed_multiplier
	target.move_and_slide()
	# Set animations
	var relative_dir = (player_model.basis * Vector3(direction.z, 0, direction.x)).normalized()
	controlled_player.current_animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(relative_dir.z, -relative_dir.x))
	# handle shooting
	if aim_state_machine.current_state is AimingState:
		if Input.is_action_just_pressed("shoot"):
			controlled_player.gun.shoot()
		if Input.is_action_just_released("shoot"):
			controlled_player.gun.shoot_end()
		if controlled_player.gun.gun_type == Gun.GunType.BUILDGUN:
			if Input.is_action_just_pressed("build_rotate_left"):
				controlled_player.gun.rotate_left()
			if Input.is_action_just_pressed("build_rotate_right"):
				controlled_player.gun.rotate_right()

func exit():
	if controlled_player.primary_weapon != null:
		controlled_player.primary_weapon.ergonomics_multiplier = 0
	if controlled_player.secondary_weapon != null:
		controlled_player.secondary_weapon.ergonomics_multiplier = 0

func check_transitions():
	if Input.is_action_just_pressed("reload"):
		if controlled_player.gun.ammo.can_reload():
			controlled_player.gun.shoot_end()
			if controlled_player.gun.ammo is SingleLoadAmmo:
				return round_reload_loop_state
			else:
				return reloading_state
	if aim_state_machine.current_state is RelaxedState:
		controlled_player.gun.shoot_end()
		return jogging_state
	if Input.is_action_just_pressed("equip_primary"):
		equipping_state.weapon_index = 0
		return equipping_state
	if Input.is_action_just_pressed("equip_secondary"):
		equipping_state.weapon_index = 1
		return equipping_state
	elif Input.is_action_just_pressed("toggle_build_mode") and !GameManager.currently_in_wave:
		equipping_state.weapon_index = 2
		return equipping_state
	if Input.is_action_just_pressed("vault") and controlled_player.can_vault:
		return %VaultState
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input.length() == 0:
		return idle_state
	else:
		return null
