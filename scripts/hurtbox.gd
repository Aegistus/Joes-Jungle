class_name Hurtbox
extends Area3D

signal on_hurt(damage)
signal on_slow(amount, duration)

func hurt(damage):
	on_hurt.emit(damage)

func slow(amount, duration):
	on_slow.emit(amount, duration)
