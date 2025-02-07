class_name RelaxedState
extends PlayerState

@export var player_model: Node3D
@export var turn_rate: float = 10

@onready var aiming_state = $"../AimingState"
@onready var reloading_state = $"../ReloadingState"
@onready var equipping_state = $"../EquippingState"
@onready var anim_tree = $"../../PlayerModel/Model/AnimTree"
@onready var movement_state_machine = $"../../MovementStateMachine"

func enter():
	controlled_player.set_upper_body_anims("", 0)

func process_state_physics(delta):
	# Rotate player model to look in movement direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	if input_dir != Vector2.ZERO:
		var look_dir = atan2(-target.velocity.x, -target.velocity.z)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, look_dir, delta * turn_rate)

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon"):
		return aiming_state
	elif Input.is_action_just_pressed("reload"):
		controlled_player.gun.shoot_end()
		reloading_state.previous_state = self
		return reloading_state
	elif Input.is_action_just_pressed("equip_primary"):
		equipping_state.weapon_index = 0
		equipping_state.previous_state = self
		return equipping_state
	elif Input.is_action_just_pressed("equip_secondary"):
		equipping_state.weapon_index = 1
		equipping_state.previous_state = self
		return equipping_state
	else:
		return null
