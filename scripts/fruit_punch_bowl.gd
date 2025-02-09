class_name FruitPunchBowl
extends Interactable

@export var item_cost : int
@export var healing_amount := 25
@onready var heal_audio_player = $HealAudioPlayer
@onready var failure_audio_player = $FailureAudioPlayer

func _ready():
	tooltip_text += " ($" + str(item_cost) + " Joe Bucks)"

func interact_start():
	if GameManager.current_points >= item_cost:
		GameManager.spend_points(item_cost)
		var player = get_tree().get_first_node_in_group("player")
		player.heal(healing_amount)
		heal_audio_player.play()
	else:
		failure_audio_player.play()
