extends Node3D

@export var player: Node3D
@export var max_camera_distance: float = 10
@export var directional_reference: Node3D

var aim_reticle : Node3D
var distance_offset = 3

const CAM_MOVE_SPEED = 20.0

func _process(delta):
	if aim_reticle == null:
		aim_reticle = get_tree().get_first_node_in_group("aim_reticle")
	if %AimStateMachine.current_state == %AimingState:
		top_level = true
		var total_distance = player.global_position.distance_to(aim_reticle.global_position)
		var ratio
		if total_distance > distance_offset:
			ratio = distance_offset / total_distance
		else:
			ratio = 1
		var target_position = aim_reticle.global_position.lerp(player.global_position, ratio)
		global_position = global_position.move_toward(target_position, delta * CAM_MOVE_SPEED)
	else:
		top_level = false
		position = Vector3.ZERO
