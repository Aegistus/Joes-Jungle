class_name SingleLoadAmmo
extends Ammo

@export var max_carried_ammo : int
@export var max_loaded_ammo : int

var current_carried_ammo : int

func _ready():
	current_ammo = max_loaded_ammo
	current_carried_ammo = max_carried_ammo

func reload():
	if max_loaded_ammo - current_ammo > current_carried_ammo:
		current_ammo += current_carried_ammo
		current_carried_ammo = 0
	else:
		var added = max_loaded_ammo - current_ammo
		current_ammo += added
		current_carried_ammo -= added
	on_reload.emit(current_carried_ammo)

func use_ammo():
	current_ammo -= 1

func can_reload() -> bool:
	if current_carried_ammo > 0 and current_ammo < max_loaded_ammo:
		return true
	else:
		return false
