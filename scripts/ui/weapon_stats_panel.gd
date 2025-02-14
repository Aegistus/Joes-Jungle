extends Panel

@onready var player = get_tree().get_first_node_in_group("player") as Player

@onready var gun_name_label = %GunNameLabel
@onready var damage_label = %DamageLabel
@onready var accuracy_progress_bar = %AccuracyProgressBar
@onready var accuracy_label = %AccuracyLabel
@onready var recoil_progress_bar = %RecoilProgressBar
@onready var recoil_label = %RecoilLabel
@onready var ergonomics_progress_bar = %ErgonomicsProgressBar
@onready var ergonomics_label = %ErgonomicsLabel

func _ready():
	player.on_pickup_weapon.connect(show_panel)
	show_panel(player.gun)

func show_panel(gun : Gun):
	gun_name_label.text = gun.gun_name
	damage_label.text = str(gun.min_damage) + "-" + str(gun.max_damage)
	accuracy_progress_bar.value = gun.base_accuracy
	accuracy_label.text = str(gun.base_accuracy)
	recoil_progress_bar.value = gun.base_recoil
	recoil_label.text = str(gun.base_recoil)
	ergonomics_progress_bar.value = gun.base_ergonomics
	ergonomics_label.text = str(gun.base_ergonomics)
	visible = true
	await get_tree().create_timer(5).timeout
	visible = false
