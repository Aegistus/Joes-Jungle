class_name BulletTrailSpawner
extends Node3D

const BULLET_TRAIL = preload("res://scenes/particles/bullet_trail.tscn")

func spawn_bullet_trail(hit_point : Vector3):
	var trail = BULLET_TRAIL.instantiate()
	get_tree().current_scene.add_child(trail)
	trail.global_position = global_position
	trail.global_rotation = global_rotation
	trail.target_position = hit_point
