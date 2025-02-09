class_name AmmoBox
extends Interactable

@export var ammo_cost = 50
@export var cooldown = 60

@onready var shop_success_audio_player = $ShopSuccessAudioPlayer
@onready var shop_failure_audio_player = $ShopFailureAudioPlayer
@onready var cooldown_timer = $CooldownTimer
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D

func _ready():
	tooltip_text += " ($" + str(ammo_cost) + " Joe Bucks)"
	animation_player.animation_changed.connect(func(anim_name):
		if anim_name == "close":
			animation_player.play("idle close"))
	animation_player.animation_changed.connect(func(anim_name):
		if anim_name == "open":
			animation_player.play("idle close"))

func interact_start():
	if GameManager.current_points >= ammo_cost:
		GameManager.spend_points(ammo_cost)
		var player = get_tree().get_first_node_in_group("player") as Player
		if player.primary_weapon != null:
			player.primary_weapon.ammo.refill_ammo()
		if player.secondary_weapon != null:
			player.secondary_weapon.ammo.refill_ammo()
		shop_success_audio_player.play()
		animation_player.play("close")
		
		collision_shape_3d.disabled = true
		cooldown_timer.wait_time = cooldown
		cooldown_timer.timeout.connect(reset)
		cooldown_timer.start()
	else:
		shop_failure_audio_player.play()

func reset():
	animation_player.play("open")
	
	collision_shape_3d.disabled = false
