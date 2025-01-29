class_name IdleState
extends PlayerState

@export var animation_tree: AnimationTree

func enter() -> void:
	super()

func process_state(delta):
	animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(controlled_player.velocity.x, -controlled_player.velocity.z))

func process_state_physics(delta):
	controlled_player.velocity.x = move_toward(controlled_player.velocity.x, 0, movement_speed)
	controlled_player.velocity.z = move_toward(controlled_player.velocity.z, 0, movement_speed)
