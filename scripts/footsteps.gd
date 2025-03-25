extends Node3D

@onready var flesh_footstep_player = $FleshFootstepPlayer
@onready var wood_footstep_player = $WoodFootstepPlayer
@onready var stone_footstep_player = $StoneFootstepPlayer
@onready var grass_footstep_player = $GrassFootstepPlayer
@onready var ray_cast_3d = $RayCast3D

var enabled = true

func play_footsteps():
	if enabled:
		var collider = ray_cast_3d.get_collider()
		if collider is CSGShape3D:
			var shape = collider as CSGShape3D
			if shape.get_collision_layer_value(17): # flesh
				flesh_footstep_player.play()
			if shape.get_collision_layer_value(18): # wood
				wood_footstep_player.play()
			if shape.get_collision_layer_value(19): # stone
				stone_footstep_player.play()
			if shape.get_collision_layer_value(20): # grass
				grass_footstep_player.play()

func _process(delta):
	flesh_footstep_player.volume_db = lerpf(-80, -20, GameManager.current_linear_insanity)
	wood_footstep_player.volume_db = lerpf(-20, -80, GameManager.current_insanity)
