extends Panel

@onready var weapon_name = $AmmoPanelUI/MarginContainer/WeaponName
@onready var magazine_ui = $AmmoPanelUI/Icons/MagazineIcon
@onready var shotgun_shells_ui = $AmmoPanelUI/Icons/ShellsIcon
@onready var ammo_count = $AmmoPanelUI/AmmoCount

var last_weapon

func _ready():
	var player = get_tree().get_first_node_in_group("player") as Player
	player.on_equip_weapon.connect(update_weapon_ui)
	await get_tree().process_frame
	update_weapon_ui(player.gun)

func update_weapon_ui(weapon : Gun):
	if last_weapon != null:
		last_weapon.ammo.on_reload.disconnect(update_carried)
	weapon_name.text = weapon.gun_name
	weapon_name.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(weapon_name, "visible_ratio", 1, .5)
	if weapon.gun_type == Gun.GunType.PISTOL or weapon.gun_type == Gun.GunType.RIFLE:
		magazine_ui.visible = true
		shotgun_shells_ui.visible = false
		ammo_count.text = "X " + str((weapon.ammo as MagazineAmmo).current_mag_count)
	elif weapon.gun_type == Gun.GunType.SHOTGUN or weapon.gun_type == Gun.GunType.REVOLVER:
		magazine_ui.visible = false
		shotgun_shells_ui.visible = true
		ammo_count.text = "X " + str((weapon.ammo as SingleLoadAmmo).current_carried_ammo)
	weapon.ammo.on_reload.connect(update_carried)
	update_carried(weapon.ammo.carried_count(), weapon.ammo.low_on_ammo())
	last_weapon = weapon
	
func update_carried(mags_or_ammo : int, ammo_low: bool):
	ammo_count.text = "X " + str(mags_or_ammo)
	if ammo_low:
		ammo_count.add_theme_color_override("font_color", Color.RED)
	else:
		ammo_count.add_theme_color_override("font_color", Color.WHITE)
