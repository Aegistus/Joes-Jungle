class_name WalkingState
extends PlayerState

@export var movement_speed: float = 100
@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var aim_state_machine: StateMachine
@export var rest_state: State
@export_category("Transition States")
@export var idle_state: State
@export var jogging_state: State
@onready var reloading_state = $"../ReloadingState"

func enter():
	super()
	animation_tree.active = true

func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction != Vector3.ZERO:
		target.velocity.x = direction.x * movement_speed * delta
		target.velocity.z = direction.z * movement_speed * delta
	target.	move_and_slide()
	# Set animations
	var relative_dir = (player_model.basis * Vector3(direction.z, 0, direction.x)).normalized()
	animation_tree.set("parameters/WalkSpeed/blend_position", Vector2(relative_dir.z, -relative_dir.x))
	# handle shooting
	if aim_state_machine.current_state is AimingState and Input.is_action_just_pressed("shoot"):
		var success = controlled_player.gun.shoot()
		if success:
			var collided = controlled_player.raycast.get_collider()
			if collided != null:
				print(collided.name)
			if collided != null and collided.is_in_group("enemy"):
				collided.hit(randi_range(controlled_player.min_damage, controlled_player.max_damage))


func check_transitions():
	if Input.is_action_just_pressed("reload"):
		return reloading_state
	if aim_state_machine.current_state is RelaxedState:
		return jogging_state
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input.length() == 0:
		return idle_state
	else:
		return null
