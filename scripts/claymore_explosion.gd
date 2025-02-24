extends Node3D

@onready var timer = $Timer
@onready var sparks = $Sparks
@onready var flash = $Flash
@onready var fire = $Fire
@onready var smoke = $Smoke
@onready var explosion_audio_player = $ExplosionAudioPlayer

func emit():
	sparks.emitting = true
	flash.emitting = true
	fire.emitting = true
	smoke.emitting = true
	explosion_audio_player.play()
