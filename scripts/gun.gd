class_name Gun
extends Node3D

signal on_ammo_count_change(ammo)

@export var max_ammo = 10
var current_ammo: int:
	set(value):
		current_ammo = value
		on_ammo_count_change.emit(current_ammo)

@onready var gun_audio_player = $GunAudioPlayer
@onready var dry_shot_audio_player = $DryShotAudioPlayer
@onready var muzzle_flash = $"gun model/MuzzleFlash"
@onready var muzzle_flash_2 = $"gun model/MuzzleFlash2"
@onready var animation_player = $AnimationPlayer

var can_shoot = true

func _ready():
	muzzle_flash.visible = false
	muzzle_flash_2.visible = false
	current_ammo = max_ammo

func shoot() -> bool:
	if can_shoot:
		if current_ammo > 0:
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			current_ammo -= 1
			return true
		else:
			# play dead mans click
			dry_shot_audio_player.play()
			return false
	else:
		return false

func reload():
	current_ammo = max_ammo

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot":
		can_shoot = true
