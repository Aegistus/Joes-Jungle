class_name EquippingState
extends PlayerState

@export var equip_time = 2.0

@onready var idle_state = $"../IdleState"
@onready var equip_audio_player = $"../../EquipAudioPlayer"
@onready var timer = $Timer

var weapon_index = 0
var state_complete = false
var previous_state : State

func enter():
	controlled_player.current_animation_tree.active = false
	var success
	if weapon_index == 0:
		success = controlled_player.equip_weapon(controlled_player.primary_weapon)
	else:
		success = controlled_player.equip_weapon(controlled_player.secondary_weapon)
	state_complete = !success
	if success:
		controlled_player.set_upper_body_anims("Rifle Anims/equip weapon", controlled_player.ANIM_BLEND)
		timer.wait_time = equip_time
		timer.timeout.connect(func(anim_name): state_complete = true)
		timer.start()
		equip_audio_player.play()

func check_transitions():
	if state_complete:
		return previous_state
