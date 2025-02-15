class_name Slowbox
extends Area3D

@export var slow := .5
@export var duration := 2.0

func _on_area_entered(area):
	if area.is_in_group("hurtbox"):
		(area as Hurtbox).slow(slow, duration)
