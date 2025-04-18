class_name SingleLoadAmmo
extends Ammo

@export var max_carried_ammo : int
@export var max_loaded_ammo : int

var current_carried_ammo : int

func _ready():
	current_ammo = max_loaded_ammo
	current_carried_ammo = max_carried_ammo

func reload():
	if current_carried_ammo == 0 or current_ammo >= max_loaded_ammo:
		return
	current_ammo += 1
	current_carried_ammo -= 1
	on_reload.emit(current_carried_ammo, low_on_ammo())

func can_reload() -> bool:
	if current_carried_ammo > 0 and current_ammo < max_loaded_ammo:
		return true
	else:
		return false

func refill_ammo():
	current_carried_ammo = max_carried_ammo
	on_reload.emit(current_carried_ammo, low_on_ammo())

func low_on_ammo() -> bool:
	if current_carried_ammo < float(max_carried_ammo) / 2:
		return true
	else:
		return false

func carried_count():
	return current_carried_ammo
