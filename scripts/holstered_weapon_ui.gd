extends Panel

@onready var weapon_name = $AmmoPanelUI/WeaponName
@onready var keyboard_key = $AmmoPanelUI/KeyboardKey/KeyboardKey

var player : Player

func _ready():
	player = get_tree().get_first_node_in_group("player") as Player
	player.on_equip_weapon.connect(update_weapon_ui)
	update_weapon_ui(player.gun)

func update_weapon_ui(equipped_weapon : Gun):
	var key = 2 if equipped_weapon == player.primary_weapon else 1
	var holstered_weapon = player.primary_weapon if key == 1 else player.secondary_weapon
	if holstered_weapon == null:
		visible = false
	else:
		weapon_name.text = holstered_weapon.gun_name
		keyboard_key.text = str(key)
		visible = true
