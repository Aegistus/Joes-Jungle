class_name Gun
extends Node3D

enum GunType { PISTOL, RIFLE, SHOTGUN }

signal on_ammo_count_change(ammo)
signal on_shoot

@export var min_damage = 6
@export var max_damage = 10
@export var max_ammo = 10
@export var suppressed = false
@export var gun_type: GunType
var current_ammo: int:
	set(value):
		current_ammo = value
		on_ammo_count_change.emit(current_ammo)

@onready var gun_audio_player = $GunAudioPlayer
@onready var dry_shot_audio_player = $DryShotAudioPlayer
@onready var muzzle_flash = $"gun model/MuzzleFlash"
@onready var muzzle_flash_2 = $"gun model/MuzzleFlash2"
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var raycast = $"gun model/RayCast3D"

var can_shoot = true

func _ready():
	if !suppressed:
		muzzle_flash.visible = false
		muzzle_flash_2.visible = false
	current_ammo = max_ammo

func shoot():
	if can_shoot:
		if current_ammo > 0:
			animation_player.stop(true)
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			current_ammo -= 1
			var collided = raycast.get_collider()
			if collided != null and collided.is_in_group("enemy"):
				collided.hit(randi_range(min_damage, max_damage))
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()

func shoot_end():
	pass

func reload():
	current_ammo = max_ammo

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot":
		can_shoot = true
