class_name Shotgun
extends Gun

func shoot():
	if can_shoot:
		if ammo.current_ammo > 0:
			animation_player.stop(true)
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			ammo.use_ammo()
			for i in raycast_parent.get_child_count():
				var raycast = raycast_parent.get_child(i) as RayCast3D
				var collided = raycast.get_collider()
				if collided == null:
					collided = raycast.get_collider() as CSGShape3D
				if collided != null:
					generate_impact_effects(collided, raycast.get_collision_point(), raycast.get_collision_normal())
					if collided != null and collided.is_in_group("enemy"):
						var rotation = (raycast.get_collision_point() - global_position).normalized().inverse()
						rotation.y += 180
						collided.hit(randi_range(min_damage, max_damage), raycast.get_collision_point(), rotation)
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()
