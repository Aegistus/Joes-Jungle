class_name Shotgun
extends Gun

@export var raycasts : Array[RayCast3D]

func shoot():
	if can_shoot:
		if ammo.current_ammo > 0:
			animation_player.stop(true)
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			ammo.current_ammo -= 1
			for i in raycasts.size():
				var collided = raycasts[i].get_collider()
				if collided != null and collided.is_in_group("enemy"):
					var rotation = (raycasts[i].get_collision_point() - global_position).normalized().inverse()
					rotation.y += 180
					collided.hit(randi_range(min_damage, max_damage), raycasts[i].get_collision_point(), rotation)
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()
