class_name AmmoBox
extends Interactable

@export var ammo_cost = 50

@onready var shop_success_audio_player = $ShopSuccessAudioPlayer
@onready var shop_failure_audio_player = $ShopFailureAudioPlayer

func _ready():
	tooltip_text += " ($" + str(ammo_cost) + " Joe Bucks)"

func interact_start():
	if GameManager.current_points >= ammo_cost:
		GameManager.spend_points(ammo_cost)
		var player = get_tree().get_first_node_in_group("player") as Player
		if player.primary_weapon != null:
			player.primary_weapon.ammo.refill_ammo()
		if player.secondary_weapon != null:
			player.secondary_weapon.ammo.refill_ammo()
		shop_success_audio_player.play()
	else:
		shop_failure_audio_player.play()
