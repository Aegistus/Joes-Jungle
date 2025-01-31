extends Node3D

@onready var gun_audio_player = $GunAudioPlayer
@onready var muzzle_flash = $"gun model/MuzzleFlash"
@onready var muzzle_flash_2 = $"gun model/MuzzleFlash2"

func _ready():
	muzzle_flash.visible = false
	muzzle_flash_2.visible = false

func shoot():
	gun_audio_player.play()
