class_name ReloadingState
extends PlayerState

@export var reload_time = 2

@onready var idle_state = $"../IdleState"
@onready var timer = $Timer

var done_reloading = false
var previous_state : State

func enter():
	controlled_player.velocity = Vector3.ZERO
	done_reloading = false
	controlled_player.set_upper_body_anims(controlled_player.current_reload_anim, controlled_player.ANIM_BLEND)
	timer.wait_time = reload_time
	timer.timeout.connect(func(anim_name): done_reloading = true)
	timer.start()

func check_transitions():
	if done_reloading:
		controlled_player.gun.reload()
		return previous_state
	else:
		return null
