extends Node3D

@export var player: Node3D
@export var max_camera_distance: float = 10
@export var directional_reference: Node3D

const CAM_MOVE_SPEED = 5.0

func _process(delta):
	#var mouse_velocity = Input.get_last_mouse_velocity()
	#if mouse_velocity.length() > 0:
		#if position.distance_to(player.position) < max_camera_distance:
			#var direction = (directional_reference.basis * Vector3(mouse_velocity.x, 0, mouse_velocity.y)).normalized()
			#direction *= CAM_MOVE_SPEED * delta
			#position += direction
	#elif position.distance_to(player.position) > .01:
		#var velocity = position.direction_to(player.position) * CAM_MOVE_SPEED * delta
		#position += velocity
	pass
