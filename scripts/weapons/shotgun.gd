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
				shoot_with_raycast(raycast)
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()
