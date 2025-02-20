class_name IdleState
extends PlayerState

@export var stopping_speed: float = 10
@export var animation_player: AnimationPlayer
@export var aim_state_machine: StateMachine

@export_group("Transition States")
@export var walking_state: State
@export var jogging_state: State
@onready var reloading_state = $"../ReloadingState"
@onready var equipping_state = $"../EquippingState"
@onready var round_reload_loop_state = %RoundReloadLoopState

func process_state(delta):
	if aim_state_machine.current_state is AimingState:
		controlled_player.current_animation_tree.active = true
		controlled_player.current_animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(controlled_player.velocity.x, -controlled_player.velocity.z))
	else:
		controlled_player.current_animation_tree.active = false
		animation_player.play(controlled_player.current_relaxed_idle_anim)

func process_state_physics(delta):
	controlled_player.velocity.x = move_toward(controlled_player.velocity.x, 0, stopping_speed)
	controlled_player.velocity.z = move_toward(controlled_player.velocity.z, 0, stopping_speed)
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

func check_transitions():

	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if aim_state_machine.current_state is RelaxedState:
			controlled_player.gun.shoot_end()
			return jogging_state
		else:
			return walking_state
	elif Input.is_action_just_pressed("reload"):
		controlled_player.gun.shoot_end()
		if controlled_player.gun.ammo is SingleLoadAmmo:
			return round_reload_loop_state
		else:
			return reloading_state
	elif Input.is_action_just_pressed("equip_primary"):
		equipping_state.weapon_index = 0
		return equipping_state
	elif Input.is_action_just_pressed("equip_secondary"):
		equipping_state.weapon_index = 1
		return equipping_state
	elif Input.is_action_just_pressed("toggle_build_mode") and !GameManager.currently_in_wave:
		equipping_state.weapon_index = 2
		return equipping_state
	else:
		return null
