class_name Gun
extends Node3D

enum GunType { PISTOL, REVOLVER, RIFLE, SHOTGUN, BUILDGUN }

signal on_shoot

@export var gun_name : String
@export var min_damage = 6
@export var max_damage = 9
@export var gun_type: GunType
@export var magazine : Node3D
@export var magazine_scale = 1.0
@export var base_accuracy = 100
@export var base_recoil = 0
@export var base_ergonomics = 100
@export var base_penetration = 1

@onready var gun_audio_player = $GunAudioPlayer
@onready var dry_shot_audio_player = $DryShotAudioPlayer
@onready var animation_player = $AnimationPlayer as AnimationPlayer
@onready var remove_mag_audio_player = $RemoveMagAudioPlayer
@onready var insert_mag_audio_player = $InsertMagAudioPlayer
@onready var ammo = $Ammo as Ammo
@onready var raycast_parent = %RaycastParent as Node3D

const BULLET_IMPACT_TERRAIN = preload("res://scenes/particles/bullet_impact_terrain.tscn")
const DEGREE_PER_ACCURACY_POINT = .05
const RECOIL_ACCURACY_CHANGE = .3
const RECOIL_RECOVERY_SPEED = 2.0
const MIN_ACCURACY = -50
const RECOIL_RECOVERY_DELAY = .1
const PENETRATION_DAMAGE_REDUCTION = .25
@onready var flesh_hit = preload("res://scenes/audio_scenes/flesh_hit_audio_source.tscn")
@onready var wood_hit = preload("res://scenes/audio_scenes/wood_hit_audio_source.tscn")
@onready var stone_hit = preload("res://scenes/audio_scenes/stone_hit_audio_source.tscn")

@onready var current_accuracy = base_accuracy
var can_shoot = true
var recoil_recovery_timer : Timer
var ergo_adjusted_accuracy:
	get:
		return base_accuracy - ((100 - base_ergonomics) * ergonomics_multiplier)
var ergonomics_multiplier := 0.0

const MAG_DESPAWN_TIME = 60

func _ready():
	if %MuzzleFlash != null:
		%MuzzleFlash.visible = false
	recoil_recovery_timer = Timer.new()
	add_child(recoil_recovery_timer)
	recoil_recovery_timer.one_shot = true
	recoil_recovery_timer.wait_time = RECOIL_RECOVERY_DELAY

func _process(delta):
	if current_accuracy != ergo_adjusted_accuracy and recoil_recovery_timer.time_left == 0:
		current_accuracy = lerpf(current_accuracy, ergo_adjusted_accuracy, RECOIL_RECOVERY_SPEED * delta)
		if abs(ergo_adjusted_accuracy - current_accuracy) < 1:
			current_accuracy = ergo_adjusted_accuracy

func shoot():
	if can_shoot:
		if ammo.current_ammo > 0:
			animation_player.stop(true)
			animation_player.play("shoot")
			gun_audio_player.play()
			can_shoot = false
			var raycast = raycast_parent.get_child(0) as RayCast3D
			shoot_with_raycast(raycast)
			ammo.use_ammo()
			on_shoot.emit()
		else:
			# play dead mans click
			dry_shot_audio_player.play()

func shoot_end():
	pass

func shoot_with_raycast(raycast : RayCast3D):
	# apply accuracy
	raycast.rotation_degrees = Vector3(0,0,0)
	var inaccuracy = (100 - current_accuracy) * randf()
	var degree_change = inaccuracy * DEGREE_PER_ACCURACY_POINT
	var radians_change = degree_change * (PI / 180.0)
	var axis = Vector3(randf() * 2 - 1, 0, randf() * 2 - 1).normalized()
	raycast.rotate_object_local(axis, radians_change)
	# shoot with penetration
	var already_hit : Array[CollisionObject3D] = []
	for i in base_penetration:
		raycast.force_raycast_update()
		var collided = raycast.get_collider() as CollisionObject3D
		var collision_point = raycast.get_collision_point()
		var collision_normal = raycast.get_collision_normal()
		if collided == null:
			collided = raycast.get_collider() as CSGShape3D
			if collided != null:
				generate_impact_effects(collided, collision_point, collision_normal)
			break
		if collided != null:
			generate_impact_effects(collided, collision_point, collision_normal)
			if collided.is_in_group("enemy"):
				var rotation = (collision_point - global_position).normalized().inverse()
				rotation.y += 180
				var damage = randi_range(min_damage, max_damage)
				damage -= i * PENETRATION_DAMAGE_REDUCTION * damage
				collided.hit(damage, collision_point, rotation)
				already_hit.append(collided)
				raycast.add_exception(collided)
	for i in already_hit.size():
		raycast.remove_exception(already_hit[i])
	# apply recoil
	current_accuracy -= base_recoil * RECOIL_ACCURACY_CHANGE
	current_accuracy = clampf(current_accuracy, MIN_ACCURACY, base_accuracy)
	#print(current_accuracy)
	recoil_recovery_timer.start()

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
	if magazine != null and magazine.visible:
		return
	insert_mag_audio_player.play()
	if magazine:
		magazine.visible = true

func generate_impact_effects(collided, collision_point, collision_normal):
	if collided.is_in_group("enemy"):
		var hit_audio = flesh_hit.instantiate()
		get_parent().add_child(hit_audio)
		hit_audio.global_position = collision_point
	else:
		var impact = BULLET_IMPACT_TERRAIN.instantiate()
		collided.add_child(impact)
		impact.global_position = collision_point
		var direction = impact.global_position + collision_point
		if collision_normal != Vector3.UP: # this check prevents occasional error
			impact.look_at(direction)
		impact.emitting = true
		if (collided.collision_layer & 1 << 17) == 1 << 17: # wood
			var hit_audio = wood_hit.instantiate()
			get_parent().add_child(hit_audio)
			hit_audio.global_position = collision_point
		else: # stone hit
			var hit_audio = stone_hit.instantiate()
			get_parent().add_child(hit_audio)
			hit_audio.global_position = collision_point

func equip(player : Node3D):
	pass

func unequip():
	pass
