class_name RoundReloadLoopState
extends PlayerState

@export var walk_speed := 200.0

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer" as AnimationPlayer
@onready var idle_state = %IdleState
@onready var directional_reference = $"../../CameraMount/Camera3D/Directional_Reference"
@onready var round_reload_anim_tree = $"../../PlayerModel/Model/RoundReloadAnimTree" as AnimationTree

var finished = false
var cancel = false

func enter():
	super()
	controlled_player.current_animation_tree.active = false
	finished = false
	cancel = false
	round_reload_anim_tree.active = true
	#animation_player.play("Michael Misc/single round reload loop")
	round_reload_anim_tree.animation_finished.connect(
		func(_name): 
			if _name == "Michael Misc/single round reload loop":
				finished = true
	)
	%AimStateMachine.transition_to(%RelaxedState)

func process_state_physics(delta):
	if Input.is_action_just_pressed("shoot"):
		cancel = true
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	target.velocity.x = direction.x * walk_speed * delta
	target.velocity.z = direction.z * walk_speed * delta
	target.move_and_slide()
	round_reload_anim_tree.set("parameters/Movement/blend_position", direction.length())

func check_transitions() -> State:
	if finished:
		controlled_player.gun.ammo.reload()
		if controlled_player.gun.ammo.can_reload():
			return self
		else:
			return idle_state
	if cancel:
		return idle_state
	return null

func exit():
	controlled_player.current_animation_tree.active = true
	round_reload_anim_tree.active = false
