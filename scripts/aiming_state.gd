class_name AimingState
extends PlayerState

@export var camera: Camera3D
@export var player_model: Node3D
@export var resting_state: State

var ray_origin = Vector3()
var ray_end = Vector3()

func process_state_physics(delta):
	var space_state = target.get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var intersection = space_state.intersect_ray(query)
	if not intersection.is_empty():
		var pos = intersection.position
		player_model.look_at(Vector3(pos.x, pos.y, pos.z), Vector3.UP)
	

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon"):
		return resting_state
