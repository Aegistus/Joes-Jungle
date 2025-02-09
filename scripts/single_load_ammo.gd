class_name SingleLoadAmmo
extends Ammo

@export var max_carried_ammo : int
@export var max_loaded_ammo : int

var carried_ammo : int

func can_reload() -> bool:
	if carried_ammo > 0:
		return true
	else:
		return false
