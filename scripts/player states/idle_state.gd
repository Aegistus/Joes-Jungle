class_name IdleState
extends PlayerState

@export var stopping_speed: float = 10
@export var animation_player: AnimationPlayer
@export var animation_tree: AnimationTree
@export var aim_state_machine: StateMachine

@export_group("Transition States")
@export var walking_state: State
@export var jogging_state: State
@onready var reloading_state = $"../ReloadingState"

func enter() -> void:
	super()

func process_state(delta):
	if aim_state_machine.current_state is AimingState:
		animation_tree.active = true
		animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(controlled_player.velocity.x, -controlled_player.velocity.z))
	else:
		animation_tree.active = false
		animation_player.play("Pistol Anim Pack/Relaxed Idle")

func process_state_physics(delta):
	controlled_player.velocity.x = move_toward(controlled_player.velocity.x, 0, stopping_speed)
	controlled_player.velocity.z = move_toward(controlled_player.velocity.z, 0, stopping_speed)
	# handle shooting
	if aim_state_machine.current_state is AimingState and Input.is_action_just_pressed("shoot"):
		var collided = controlled_player.raycast.get_collider()
		if collided != null:
			print(collided.name)
		if collided != null and collided.is_in_group("enemy"):
			collided.hit(randi_range(controlled_player.min_damage, controlled_player.max_damage))
		controlled_player.pistol_92.shoot()

func check_transitions():
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		if aim_state_machine.current_state is RelaxedState:
			return jogging_state
		else:
			return walking_state
	elif Input.is_action_just_pressed("reload"):
		return reloading_state
	else:
		return null
