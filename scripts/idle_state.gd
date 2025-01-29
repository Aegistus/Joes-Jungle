class_name IdleState
extends PlayerState

func enter() -> void:
	super()

func process_state_physics(delta):
	player_owner.velocity.x = move_toward(player_owner.velocity.x, 0, movement_speed)
	player_owner.velocity.z = move_toward(player_owner.velocity.z, 0, movement_speed)
