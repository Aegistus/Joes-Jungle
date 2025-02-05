extends Node3D

@onready var laser_raycast = $LaserRaycast as RayCast3D

var laser_mesh

func _process(delta):
	if laser_mesh:
		laser_mesh.queue_free()
		laser_mesh = null
	if !is_visible_in_tree():
		return
	var target_point
	if laser_raycast.is_colliding():
		target_point = laser_raycast.get_collision_point()
	else:
		target_point = laser_raycast.global_transform * laser_raycast.target_position
	laser_mesh = line(laser_raycast.global_position, target_point)

func line(pos1: Vector3, pos2: Vector3, color = Color.SPRING_GREEN) -> MeshInstance3D:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	get_tree().get_root().add_child(mesh_instance)
	
	return mesh_instance
