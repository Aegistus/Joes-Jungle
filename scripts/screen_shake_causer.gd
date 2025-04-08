class_name ScreenShakeCauser
extends Area3D

@export var shake_amount := 0.1

func cause_shake():
	var shake_areas = get_overlapping_areas()
	for area in shake_areas:
		if area is ShakeableCamera:
			area.add_screen_shake(shake_amount)
