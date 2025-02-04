class_name Shotgun
extends Gun

@export var raycasts : Array[RayCast3D]

func shoot():
	if can_shoot:
		if current_ammo > 0:
			animation_player.stop(true)
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			current_ammo -= 1
			for i in raycasts.size():
				var collided = raycasts[i].get_collider()
				if collided != null and collided.is_in_group("enemy"):
					collided.hit(randi_range(min_damage, max_damage))
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()
