class_name EquippingState
extends PlayerState

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"
@onready var idle_state = $"../IdleState"

var weapon_index = 0
var state_complete = false

func enter():
	controlled_player.current_animation_tree.active = false
	if weapon_index == 0:
		controlled_player.equip_weapon(controlled_player.primary_weapon)
	else:
		controlled_player.equip_weapon(controlled_player.secondary_weapon)
	state_complete = false
	animation_player.play("Rifle Anims/equip weapon")
	animation_player.animation_finished.connect(func(anim_name): state_complete = true)

func check_transitions():
	if state_complete:
		return idle_state
