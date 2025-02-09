class_name Gun
extends Node3D

enum GunType { PISTOL, RIFLE, SHOTGUN }

signal on_shoot

@export var min_damage = 6
@export var max_damage = 9
@export var suppressed = false
@export var gun_type: GunType
@export var magazine : Node3D
@export var magazine_scale = 1.0

@onready var gun_audio_player = $GunAudioPlayer
@onready var dry_shot_audio_player = $DryShotAudioPlayer
@onready var muzzle_flash = $"gun model/MuzzleFlash"
@onready var muzzle_flash_2 = $"gun model/MuzzleFlash2"
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var raycast = $"gun model/RayCast3D" as RayCast3D
@onready var remove_mag_audio_player = $RemoveMagAudioPlayer
@onready var insert_mag_audio_player = $InsertMagAudioPlayer
@onready var ammo = $Ammo

const BULLET_IMPACT_TERRAIN = preload("res://scenes/particles/bullet_impact_terrain.tscn")
@onready var flesh_hit = preload("res://scenes/audio_scenes/flesh_hit_audio_source.tscn")
@onready var wood_hit = preload("res://scenes/audio_scenes/wood_hit_audio_source.tscn")
@onready var stone_hit = preload("res://scenes/audio_scenes/stone_hit_audio_source.tscn")

var can_shoot = true

const MAG_DESPAWN_TIME = 60

func _ready():
	if !suppressed:
		muzzle_flash.visible = false
		muzzle_flash_2.visible = false

func shoot():
	if can_shoot:
		if ammo.current_ammo > 0:
			animation_player.stop(true)
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			var collided = raycast.get_collider() as CollisionObject3D
			if collided == null:
				collided = raycast.get_collider() as CSGShape3D
			if collided != null:
				generate_impact_effects(collided)
				if collided.is_in_group("enemy"):
					var rotation = (raycast.get_collision_point() - global_position).normalized().inverse()
					rotation.y += 180
					collided.hit(randi_range(min_damage, max_damage), raycast.get_collision_point(), rotation)
			ammo.use_ammo()
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()

func shoot_end():
	pass

func reload():
	ammo.reload()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "shoot":
		can_shoot = true

func remove_magazine() -> Node3D:
	remove_mag_audio_player.play()
	if magazine:
		var copy = magazine.duplicate()
		copy.global_scale(Vector3(magazine_scale, magazine_scale, magazine_scale))
		magazine.visible = false
		return copy
	else:
		return null

func insert_magazine():
	if magazine.visible:
		return
	insert_mag_audio_player.play()
	if magazine:
		magazine.visible = true
	

func generate_impact_effects(collided):
	if collided.is_in_group("enemy"):
		var hit_audio = flesh_hit.instantiate()
		get_parent().add_child(hit_audio)
		hit_audio.global_position = raycast.get_collision_point()
	else:
		var impact = BULLET_IMPACT_TERRAIN.instantiate()
		collided.add_child(impact)
		impact.global_position = raycast.get_collision_point()
		var direction = impact.global_position + raycast.get_collision_normal()
		if raycast.get_collision_normal() != Vector3.UP: # this check prevents occasional error
			impact.look_at(direction)
		impact.emitting = true
		if (collided.collision_layer & 1 << 17) == 1 << 17: # wood
			var hit_audio = wood_hit.instantiate()
			get_parent().add_child(hit_audio)
			hit_audio.global_position = raycast.get_collision_point()
		else: # stone hit
			var hit_audio = stone_hit.instantiate()
			get_parent().add_child(hit_audio)
			hit_audio.global_position = raycast.get_collision_point()
