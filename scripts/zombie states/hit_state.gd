class_name HitState
extends ZombieState

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"

var animation_done = false

func enter():
	animation_done = false
	if randf() > .5:
		animation_player.play("Zombie Anims/Zombie Hit 1")
		animation_player.seek(.3)
	else:
		animation_player.play("Zombie Anims/Zombie Hit 2")
		animation_player.seek(.4)
	zombie.velocity = Vector3.ZERO
	animation_player.animation_finished.connect(func(anim_name): animation_done = true)

func check_transitions():
	if animation_done:
		return follow_state
	else:
		return null
