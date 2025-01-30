class_name WalkingState
extends PlayerState

@export var movement_speed: float = 100
@export var animation_tree: AnimationTree
@export var directional_reference: Node3D
@export_group("Transition States")
@export var idle_state: State


func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(input_dir.x, input_dir.y))
	if direction != Vector3.ZERO:
		target.velocity.x = direction.x * movement_speed * delta
		target.velocity.z = direction.z * movement_speed * delta
	
	target.	move_and_slide()

func check_transitions():
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input.length() == 0:
		return idle_state
	else:
		return null
