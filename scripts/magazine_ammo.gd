class_name MagazineAmmo
extends Ammo

@export var max_magazine_count : int
@export var magazine_round_capacity : int

var current_mag_count : int

func _ready():
	current_ammo = magazine_round_capacity
	current_mag_count = max_magazine_count

func can_reload() -> bool:
	if current_mag_count > 0:
		return true
	else:
		return false

func reload() -> bool:
	if current_mag_count == 0:
		return false
	current_mag_count -= 1
	current_ammo = magazine_round_capacity
	on_reload.emit(current_mag_count)
	return true

func refill_ammo():
	current_mag_count = max_magazine_count
	on_reload.emit(current_mag_count)
