class_name Ammo
extends Node

signal on_reload(carried_ammo_or_mags)

var current_ammo : int

func can_reload() -> bool:
	return true

func use_ammo():
	current_ammo -= 1

func reload():
	pass
