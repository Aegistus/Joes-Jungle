class_name RoundReloadLoopState
extends PlayerState

@export var movement_speed := 200.0

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer" as AnimationPlayer
@onready var round_reload_end_state = %RoundReloadEndState

var finished = false

func enter():
	super()
	controlled_player.current_animation_tree.active = false
	finished = false
	animation_player.play("Michael Misc/single round reload loop")
	animation_player.animation_finished.connect(func(_name): finished = true)

func check_transitions() -> State:
	if finished:
		controlled_player.gun.ammo.reload()
		if controlled_player.gun.ammo.can_reload():
			return self
		else:
			return round_reload_end_state
	return null

func exit():
	controlled_player.current_animation_tree.active = true
	
