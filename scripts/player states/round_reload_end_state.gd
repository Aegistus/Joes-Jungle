class_name RoundReloadEndState
extends PlayerState

@export var movement_speed := 200.0

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"
@onready var idle_state = %IdleState

var finished = false

func enter():
	super()
	controlled_player.current_animation_tree.active = false
	finished = false
	animation_player.play("Michael Misc/single round reload end")
	animation_player.animation_finished.connect(func(_name): finished = true)

func check_transitions() -> State:
	if finished:
		return idle_state
	return null

func exit():
	controlled_player.current_animation_tree.active = true
