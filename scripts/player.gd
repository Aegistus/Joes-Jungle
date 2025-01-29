extends CharacterBody3D

@export var turn_rate := 5.0
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var animation_player: AnimationPlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Rotate player model to look in movement direction
	if direction != Vector3.ZERO:
		var look_dir = atan2(-velocity.x, -velocity.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, look_dir, delta * turn_rate)
	
	if direction != Vector3.ZERO:
		animation_player.play("walking")
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
