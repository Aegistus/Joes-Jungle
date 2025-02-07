class_name AimingState
extends PlayerState

@export var camera: Camera3D
@export var player_model: Node3D

@onready var relaxed_state = $"../RelaxedState"
@onready var reloading_state = $"../ReloadingState"
@onready var equipping_state = $"../EquippingState"
@onready var anim_tree = $"../../PlayerModel/Model/AnimTree"

var intersection

var ray_origin = Vector3()
var ray_end = Vector3()
var GROUND_MASK = 0x2

func enter():
	controlled_player.set_upper_body_anims(controlled_player.current_aim_animation, controlled_player.ANIM_BLEND)

func process_state_physics(delta):
	var space_state = target.get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	ray_origin = camera.project_ray_origin(mouse_pos)
	ray_end = ray_origin + camera.project_ray_normal(mouse_pos) * 2000
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end, GROUND_MASK)
	intersection = space_state.intersect_ray(query)
	if not intersection.is_empty():
		var pos = intersection.position
		player_model.look_at(Vector3(pos.x, pos.y, pos.z), Vector3.UP)
	

func check_transitions():
	if Input.is_action_just_pressed("aim_weapon"):
		return relaxed_state
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
