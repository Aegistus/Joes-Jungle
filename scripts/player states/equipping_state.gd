class_name EquippingState
extends PlayerState

@export var movement_speed = 100
@export var equip_time = .75

@onready var animation_player = $"../../PlayerModel/Model/AnimationPlayer"
@onready var idle_state = $"../IdleState" as IdleState
@onready var equip_audio_player = $"../../EquipAudioPlayer"
@onready var equip_anim_tree = $"../../PlayerModel/Model/EquipAnimTree" as AnimationTree
@onready var aim_state_machine = $"../../AimStateMachine"
@onready var relaxed_state = $"../../AimStateMachine/RelaxedState"

var weapon_index = 0
var state_complete = false
var timer : Timer

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = equip_time
	timer.one_shot = true
	timer.timeout.connect(func(): state_complete = true)

func enter():
	var success
	if weapon_index == 0:
		success = controlled_player.equip_weapon(controlled_player.primary_weapon)
	elif weapon_index == 1:
		success = controlled_player.equip_weapon(controlled_player.secondary_weapon)
	elif weapon_index == 2:
		success = controlled_player.equip_weapon(controlled_player.build_gun)
	state_complete = !success
	if success:
		aim_state_machine.transition_to(relaxed_state)
		controlled_player.current_animation_tree.active = false
		equip_anim_tree.active = true
		equip_audio_player.play()
		timer.start()

func process_state_physics(delta):
	# Get the input direction and handle the movement/deceleration.]
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (%ShakeableCamera.directional_reference.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	target.velocity.x = direction.x * movement_speed * delta * controlled_player.move_speed_multiplier
	target.velocity.z = direction.z * movement_speed * delta * controlled_player.move_speed_multiplier
	target.move_and_slide()
	# update animation tree
	equip_anim_tree.set("parameters/blend_position", direction.length())

func check_transitions():
	if state_complete:
		return idle_state

func exit():
	controlled_player.current_animation_tree.active = true
	equip_anim_tree.active = false
