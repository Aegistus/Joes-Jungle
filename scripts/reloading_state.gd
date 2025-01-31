class_name ReloadingState
extends PlayerState

@onready var idle_state = $"../IdleState"
@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"
@onready var animation_tree = $"../../PlayerModel/Model/AnimationTree"

var done_reloading = false

func enter():
	animation_player.play("Pistol Anim Pack/Reloading")
	animation_tree.active = false
	controlled_player.velocity = Vector3.ZERO
	done_reloading = false
	animation_player.animation_finished.connect(func(anim_name): done_reloading = true)

func check_transitions():
	if done_reloading:
		return idle_state
	else:
		return null
