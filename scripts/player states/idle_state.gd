class_name IdleState
extends PlayerState

@export var stopping_speed: float = 10
@export var animation_player: AnimationPlayer
@export var aim_state_machine: StateMachine

@export_group("Transition States")
@export var walking_state: State
@export var jogging_state: State
@onready var reloading_state = $"../ReloadingState"

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

func check_transitions():
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if aim_state_machine.current_state is RelaxedState:
			controlled_player.gun.shoot_end()
			return jogging_state
		else:
			return walking_state
	elif Input.is_action_just_pressed("reload"):
		controlled_player.gun.shoot_end()
		return reloading_state
	else:
		return null
