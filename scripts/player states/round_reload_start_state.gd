class_name RoundReloadStartState
extends PlayerState

@export var movement_speed := 200.0

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer" as AnimationPlayer
@onready var round_reload_loop_state = %RoundReloadLoopState

var finished = false

func enter():
	super()
	controlled_player.current_animation_tree.active = false
	finished = false
	animation_player.play("Michael Misc/single round reload start")
	animation_player.animation_finished.connect(func(_name): finished = true)

func check_transitions() -> State:
	if finished:
		return round_reload_loop_state
	return null

func exit():
	controlled_player.current_animation_tree.active = true
