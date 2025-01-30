class_name IdleState
extends PlayerState

@export var animation_tree: AnimationTree
@export var stopping_speed: float = 10
@export_group("Transition States")
@export var walking_state: State

func enter() -> void:
	super()

func process_state(delta):
	animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(controlled_player.velocity.x, -controlled_player.velocity.z))

func process_state_physics(delta):
	controlled_player.velocity.x = move_toward(controlled_player.velocity.x, 0, stopping_speed)
	controlled_player.velocity.z = move_toward(controlled_player.velocity.z, 0, stopping_speed)

func check_transitions():
	if Input.is_action_pressed("move_forward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		return walking_state
	else:
		return null
