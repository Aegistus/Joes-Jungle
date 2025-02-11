extends Interactable

@export var shop_item_scene_path : String
@export var item_cost : int
@onready var animation_player = $AnimationPlayer
@onready var shop_success_audio_player = $ShopSuccessAudioPlayer
@onready var shop_failure_audio_player = $ShopFailureAudioPlayer

var shop_item

func _ready():
	shop_item = load(shop_item_scene_path)
	animation_player.play("spin")
	tooltip_text += " ($" + str(item_cost) + " Joe Bucks)"

func interact_start():
	if GameManager.current_points >= item_cost:
		GameManager.spend_points(item_cost)
		var player = get_tree().get_first_node_in_group("player") as Player
		var item_instance = shop_item.instantiate()
		player.pickup_weapon(item_instance)
		shop_success_audio_player.play()
	else:
		shop_failure_audio_player.play()
