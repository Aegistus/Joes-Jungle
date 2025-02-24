class_name UsingEmplacementState
extends PlayerState

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"

func enter():
	animation_player.play("Turret Twerk/Twerk")

func check_transitions() -> State:
	if Input.is_action_just_pressed("interact"):
		return %IdleState
	else:
		return null
