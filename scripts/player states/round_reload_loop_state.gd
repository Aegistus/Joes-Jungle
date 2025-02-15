class_name RoundReloadLoopState
extends PlayerState

@export var walk_speed := 200.0

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer" as AnimationPlayer
@onready var round_reload_end_state = %RoundReloadEndState
@onready var idle_state = %IdleState
@onready var directional_reference = $"../../CameraMount/Camera3D/Directional_Reference"

var finished = false
var cancel = false

func enter():
	super()
	controlled_player.current_animation_tree.active = false
	finished = false
	cancel = false
	animation_player.play("Michael Misc/single round reload loop")
	animation_player.animation_finished.connect(func(_name): finished = true)

func process_state_physics(delta):
	if Input.is_action_just_pressed("shoot"):
		cancel = true
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		target.velocity.x = direction.x * walk_speed * delta
		target.velocity.z = direction.z * walk_speed * delta
	target.move_and_slide()

func check_transitions() -> State:
	if finished:
		controlled_player.gun.ammo.reload()
		if controlled_player.gun.ammo.can_reload():
			return self
		else:
			return round_reload_end_state
	if cancel:
		return idle_state
	return null

func exit():
	controlled_player.current_animation_tree.active = true
	
