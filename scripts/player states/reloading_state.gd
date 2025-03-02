class_name ReloadingState
extends PlayerState

@export var movement_speed = 200

@onready var idle_state = $"../IdleState"
@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"
@onready var reload_anim_tree = $"../../PlayerModel/Model/ReloadAnimTree"
@onready var directional_reference = %DirectionalReference
@onready var aim_state_machine = $"../../AimStateMachine"
@onready var relaxed_state = $"../../AimStateMachine/RelaxedState"
@onready var aiming_state = $"../../AimStateMachine/AimingState"

var cancel = false
var done_reloading = false
var magazine_removed = false
var magazine_dropped = false
var magazine_inserted = false
var return_to_aiming = false

func enter():
	if controlled_player.gun.ammo.can_reload():
		cancel = false
		done_reloading = false
		magazine_removed = false
		magazine_dropped = false
		magazine_inserted = false
		controlled_player.current_animation_tree.active = false
		reload_anim_tree.active = true
		reload_anim_tree.set_process_callback(AnimationTree.ANIMATION_PROCESS_MANUAL)
		reload_anim_tree.animation_finished.connect(func(anim_name): done_reloading = true)
		if aim_state_machine.current_state is AimingState:
			return_to_aiming = true
		else:
			return_to_aiming = false
		aim_state_machine.transition_to(relaxed_state)
	else:
		cancel = true
		return_to_aiming = false

func process_state(delta):
	reload_anim_tree.advance(delta * controlled_player.gun.reload_anim_speed_modifier)

func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	target.velocity.x = direction.x * movement_speed * delta * controlled_player.move_speed_multiplier
	target.velocity.z = direction.z * movement_speed * delta * controlled_player.move_speed_multiplier
	target.velocity *= controlled_player.gun.reload_move_speed_modifier
	target.move_and_slide()
	# update animation tree
	reload_anim_tree.set("parameters/blend_position", direction.length())

func check_transitions():
	if cancel:
		return idle_state
	if done_reloading:
		controlled_player.gun.reload()
		return idle_state
	else:
		return null

func exit():
	reload_anim_tree.set_process_callback(AnimationTree.ANIMATION_PROCESS_IDLE)
	if return_to_aiming:
		aim_state_machine.transition_to(aiming_state)
	reload_anim_tree.active = false
	if !cancel and !magazine_inserted:
		controlled_player.insert_magazine()
