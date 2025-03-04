class_name AimingState
extends PlayerState

@export var camera: Camera3D
@export var relaxed_state: State

@onready var player_model = $"../../PlayerModel"

var intersection

var ray_origin = Vector3()
var ray_end = Vector3()
const GROUND_MASK = 0x2

func process_state_physics(delta):
	if player_model.global_position != %AimReticle.global_position:
		player_model.look_at(%AimReticle.global_position)

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon") and controlled_player.gun is not BuildGun:
		return relaxed_state
