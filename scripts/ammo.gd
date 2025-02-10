class_name Ammo
extends Node

signal on_reload(carried_ammo_or_mags, ammo_low: bool)

var current_ammo : int

func can_reload() -> bool:
	return true

func use_ammo():
	current_ammo -= 1

func reload():
	pass

func refill_ammo():
	pass

func low_on_ammo() -> bool:
	return false

func carried_count() -> int:
	return 0
