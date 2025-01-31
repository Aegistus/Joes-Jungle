extends Node3D

@export var max_ammo = 10

@onready var gun_audio_player = $GunAudioPlayer
@onready var muzzle_flash = $"gun model/MuzzleFlash"
@onready var muzzle_flash_2 = $"gun model/MuzzleFlash2"
@onready var animation_player = $AnimationPlayer

var can_shoot = true

func _ready():
	muzzle_flash.visible = false
	muzzle_flash_2.visible = false

func shoot() -> bool:
	if can_shoot:
		animation_player.play("shoot")
		gun_audio_player.play()
		can_shoot = false
		return true
	else:
		return false


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot":
		can_shoot = true
