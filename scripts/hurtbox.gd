class_name Hurtbox
extends Area3D

signal on_hurt(damage)

func hurt(damage):
	on_hurt.emit(damage)
