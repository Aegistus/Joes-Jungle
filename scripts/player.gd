class_name Player
extends CharacterBody3D

signal health_update(health, max_health)
signal on_equip_weapon(gun : Gun)
signal on_pickup_weapon(gun : Gun)

@export var turn_rate := 5.0
@export var max_health = 100
@export var directional_reference: Node3D
@export var animation_player: AnimationPlayer

@onready var interact_raycast = $PlayerModel/InteractRaycast
@onready var hurtbox = $Hurtbox

@onready var pistol_anim_tree = $PlayerModel/Model/PistolAnimTree
@onready var rifle_anim_tree = $PlayerModel/Model/RifleAnimTree
@onready var build_anim_tree = $PlayerModel/Model/BuildAnimTree

@onready var gun_holder = $PlayerModel/Model/Armature/GeneralSkeleton/RightHandBone/GunHolder
@onready var left_hand_bone = $PlayerModel/Model/Armature/GeneralSkeleton/LeftHandBone
@onready var player_model = $PlayerModel
@onready var walking_state = $MovementStateMachine/WalkingState
@onready var reloading_state = $MovementStateMachine/ReloadingState
@onready var take_damage_audio_player = $TakeDamageAudioPlayer

var primary_weapon : Gun
var secondary_weapon : Gun
var build_gun : Gun
var current_animation_tree
var current_relaxed_idle_anim
var current_relaxed_jog_anim
var gun : Gun
var magazine : RigidBody3D
var move_speed_multiplier = 1.0
var current_interactable
var current_health

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	current_health = max_health
	hurtbox.on_hurt.connect(take_damage)
	hurtbox.on_slow.connect(apply_slow)
	GameManager.on_wave_start.connect(unequip_build_gun)
	for gun in gun_holder.get_children():
		if gun is Gun:
			gun = gun as Gun
			if gun.gun_type == Gun.GunType.BUILDGUN:
				build_gun = gun
			elif secondary_weapon == null:
				secondary_weapon = gun
			elif primary_weapon == null:
				primary_weapon = gun
	if primary_weapon:
		primary_weapon.visible = false
	if secondary_weapon:
		secondary_weapon.visible = false
	equip_weapon(secondary_weapon)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var interactable = interact_raycast.get_collider()
	if interactable != null:
		if interactable.is_in_group("interactable"):
			current_interactable = interactable as Interactable
			if current_interactable == null:
				current_interactable = interactable.get_parent() as Interactable
			print(current_interactable.name)
	else:
		current_interactable = null
	if current_interactable != null:
		if Input.is_action_just_pressed("interact"):
			current_interactable.interact_start()
		if Input.is_action_pressed("interact"):
			current_interactable.interact_during(delta)
		if Input.is_action_just_released("interact"):
			current_interactable.interact_end()
	#debugging
	if Input.is_action_just_pressed("show_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	if Input.is_action_just_pressed("debug_suicide"):
		take_damage(999999)
	if Input.is_action_just_pressed("debug_add_cash"):
		GameManager.add_points(1000)

func take_damage(damage):
	if current_health > 0:
		current_health -= damage
		current_health = clampf(current_health, 0, max_health)
		health_update.emit(current_health, max_health)
		take_damage_audio_player.play()
		if current_health <= 0:
			GameManager.end_game(GameManager.CauseOfDeath.ZOMBIE)

func heal(amount):
	current_health = clampf(current_health + amount, 0, max_health)
	health_update.emit(current_health, max_health)

func equip_weapon(new_gun: Gun) -> bool:
	if new_gun == null or new_gun == gun:
		return false
	if gun != null:
		gun.visible = false
		gun.unequip()
	gun = new_gun
	gun.visible = true
	if new_gun.gun_type == Gun.GunType.PISTOL or new_gun.gun_type == Gun.GunType.REVOLVER:
		rifle_anim_tree.active = false
		build_anim_tree.active = false
		current_animation_tree = pistol_anim_tree
		current_relaxed_idle_anim = "Pistol Anim Pack/Relaxed Idle"
		current_relaxed_jog_anim = "Pistol Anim Pack/Relaxed Run"
	elif new_gun.gun_type == Gun.GunType.RIFLE or new_gun.gun_type == Gun.GunType.SHOTGUN:
		pistol_anim_tree.active = false
		build_anim_tree.active = false
		current_animation_tree = rifle_anim_tree
		current_relaxed_idle_anim = "Michael Rifle/relaxed idle"
		current_relaxed_jog_anim = "Michael Rifle/jog"
	elif new_gun.gun_type == Gun.GunType.BUILDGUN:
		pistol_anim_tree.active = false
		rifle_anim_tree.active = false
		current_animation_tree = build_anim_tree
		current_relaxed_idle_anim = "Michael Build/build_idle"
		current_relaxed_jog_anim = "Pistol Anim Pack/Relaxed Run"
	gun.equip(self)
	on_equip_weapon.emit(gun)
	return true

func unequip_weapon():
	if gun == null:
		return
	gun.unequip()
	gun.visible = false
	gun = null
	rifle_anim_tree.active = false
	pistol_anim_tree.active = false
	current_animation_tree = build_anim_tree
	current_animation_tree.active = true
	current_relaxed_idle_anim = "Michael Build/build_idle"

func pickup_weapon(new_gun: Gun):
	if primary_weapon != null and secondary_weapon != null:
		if gun == primary_weapon:
			primary_weapon = null
		elif gun == secondary_weapon:
			secondary_weapon = null
		drop_weapon(gun)
	if primary_weapon == null:
		primary_weapon = new_gun
		print("New weapon is primary")
	elif secondary_weapon == null:
		secondary_weapon = new_gun
		print("New weapon is secondary")
	gun_holder.add_child(new_gun)
	on_pickup_weapon.emit(new_gun)
	equip_weapon(new_gun)

func drop_weapon(weapon_to_drop : Gun):
	print("Dropping: " + weapon_to_drop.name)
	weapon_to_drop.queue_free()

func remove_magazine():
	if !reloading_state.magazine_removed:
		reloading_state.magazine_removed = true
		magazine = gun.remove_magazine()
		if magazine != null:
			magazine.reparent(left_hand_bone)
			magazine.global_position = left_hand_bone.global_position
			magazine.global_rotation = left_hand_bone.global_rotation

func drop_magazine():
	# do previous step in case it hasn't been done yet
	if !reloading_state.magazine_removed:
		remove_magazine()
	if !reloading_state.magazine_dropped:
		reloading_state.magazine_dropped = true
		if magazine != null:
			var global_pos = magazine.global_position
			left_hand_bone.remove_child(magazine)
			get_tree().root.add_child(magazine)
			magazine.global_position = global_pos
			magazine.freeze = false
			magazine.apply_impulse(player_model.transform * Vector3.LEFT)
			var timer = Timer.new()
			magazine.add_child(timer)
			timer.wait_time = Gun.MAG_DESPAWN_TIME
			timer.timeout.connect(func(): timer.get_parent().queue_free())
			timer.start()
		magazine = null

func insert_magazine():
	# do all previous steps in case they haven't been done yet
	if !reloading_state.magazine_removed:
		remove_magazine()
	if !reloading_state.magazine_dropped:
		drop_magazine()
	if !reloading_state.magazine_inserted:
		gun.insert_magazine()

func insert_round():
	gun.insert_mag_audio_player.play()

func apply_slow(amount, duration):
	move_speed_multiplier = 1 - amount
	await get_tree().create_timer(duration).timeout
	move_speed_multiplier = 1

func unequip_build_gun():
	if gun is BuildGun:
		%EquippingState.weapon_index = 1
		%MovementStateMachine.transition_to(%EquippingState)

func use_emplacement():
	%MovementStateMachine.transition_to(%UsingEmplacementState)
