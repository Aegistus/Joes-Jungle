extends Panel

@onready var weapon_name = $WeaponName
@onready var magazine_ui = $MagazineUi
@onready var shotgun_shells_ui = $ShotgunShellsUi
@onready var ammo_count = $AmmoCount

func _ready():
	var player = get_tree().get_first_node_in_group("player") as Player
	player.on_equip_weapon.connect(update_weapon_ui)
	update_weapon_ui(player.gun)

func update_weapon_ui(weapon : Gun):
	if weapon.gun_type == Gun.GunType.PISTOL or weapon.gun_type == Gun.GunType.RIFLE:
		magazine_ui.visible = true
		shotgun_shells_ui.visible = false
		ammo_count.text = "X " + str((weapon.ammo as MagazineAmmo).current_mag_count)
	elif weapon.gun_type == Gun.GunType.SHOTGUN:
		magazine_ui.visible = false
		shotgun_shells_ui.visible = true
		ammo_count.text = "X " + str((weapon.ammo as SingleLoadAmmo).current_carried_ammo)
	weapon.ammo.on_reload.connect(update_carried)
	
func update_carried(mags_or_ammo : int):
	ammo_count.text = "X " + str(mags_or_ammo)
