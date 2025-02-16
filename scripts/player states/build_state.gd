class_name BuildState
extends PlayerState

@onready var player_model = %PlayerModel
@onready var main_camera = %MainCamera

const GROUND_MASK = 0x2

func process_state_physics(delta):
	var space_state = target.get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = main_camera.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + main_camera.project_ray_normal(mouse_pos) * 2000
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, GROUND_MASK)
	var intersection = space_state.intersect_ray(query)
	if not intersection.is_empty():
		var pos = intersection.position
		player_model.look_at(Vector3(pos.x, pos.y, pos.z), Vector3.UP)

func check_transitions():
	if Input.is_action_just_pressed("toggle_build_mode"):
		return %RelaxedState
	return null
