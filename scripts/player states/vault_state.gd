class_name VaultState
extends PlayerState

@export var move_speed = 100

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"

var finished = false

func enter():
	finished = false
	controlled_player.current_animation_tree.active = false
	animation_player.play("Vault/vault")
	animation_player.animation_finished.connect(func(anim_name): finished = true)
	%PlayerCollider.disabled = true
	%AimStateMachine.transition_to(%RelaxedState)

func process_state_physics(delta):
	controlled_player.velocity = -%PlayerModel.global_basis.z * move_speed * delta
	controlled_player.move_and_slide()

func exit():
	%PlayerCollider.disabled = false

func check_transitions():
	if finished:
		return %IdleState
	return null
