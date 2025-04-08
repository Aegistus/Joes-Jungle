class_name AimingState
extends PlayerState

@export var relaxed_state: State

@onready var player_model = $"../../PlayerModel"

var intersection

var ray_origin = Vector3()
var ray_end = Vector3()
const GROUND_MASK = 0x2

func process_state_physics(delta):
	var space_state = target.get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	ray_origin = %ShakeableCamera.camera.project_ray_origin(mouse_pos)
	ray_end = ray_origin + %ShakeableCamera.camera.project_ray_normal(mouse_pos) * 2000
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, GROUND_MASK)
	intersection = space_state.intersect_ray(query)
	if not intersection.is_empty():
		var pos = intersection.position
		player_model.look_at(Vector3(pos.x, pos.y, pos.z), Vector3.UP)
	if player_model.global_position != %AimReticle.global_position:
		player_model.look_at(%AimReticle.global_position)

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon") and controlled_player.gun is not BuildGun:
		return relaxed_state
