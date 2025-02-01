class_name Hitbox
extends Area3D

var damage := 10

func _on_area_entered(area):
	if area.is_in_group("hurtbox"):
		(area as Hurtbox).hurt(damage)
