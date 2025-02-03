class_name Player
extends CharacterBody3D

signal health_update(health, max_health)

@export var turn_rate := 5.0
@export var max_health = 100
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var animation_player: AnimationPlayer

@onready var interact_raycast = $PlayerModel/InteractRaycast
@onready var hurtbox = $Hurtbox
@onready var primary_weapon = $PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/GunHolder/Benelli_M4
@onready var secondary_weapon = $"PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/GunHolder/Pistol 92"
@onready var pistol_anim_tree = $PlayerModel/Model/PistolAnimTree
@onready var rifle_anim_tree = $PlayerModel/Model/RifleAnimTree
@onready var gun_holder = $PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/GunHolder

var current_animation_tree
var current_relaxed_idle_anim
var current_relaxed_jog_anim
var gun : Gun

var current_interactable
var current_health

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	current_health = max_health
	hurtbox.on_hurt.connect(take_damage)
	#primary_weapon.visible = false
	secondary_weapon.visible = false
	equip_weapon(secondary_weapon)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var interactable = interact_raycast.get_collider()
	if interactable != null:
		if interactable.is_in_group("interactable"):
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
	if Input.is_action_just_pressed("show_mouse"):
		if Input.mouse_mode == Input.MOUSE_MODE_CONFINED_HIDDEN:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func take_damage(damage):
	if current_health > 0:
		current_health -= damage
		current_health = clampf(current_health, 0, max_health)
		health_update.emit(current_health, max_health)
		if current_health <= 0:
			GameManager.end_game()

func equip_weapon(new_gun: Gun) -> bool:
	if new_gun == gun:
		return false
	if gun != null:
		gun.visible = false
	gun = new_gun
	gun.visible = true
	if new_gun.gun_type == Gun.GunType.PISTOL:
		rifle_anim_tree.active = false
		current_animation_tree = pistol_anim_tree
		current_relaxed_idle_anim = "Pistol Anim Pack/Relaxed Idle"
		current_relaxed_jog_anim = "Pistol Anim Pack/Relaxed Run"
	else:
		pistol_anim_tree.active = false
		current_animation_tree = rifle_anim_tree
		current_relaxed_idle_anim = "Rifle Anims/rifle relaxed idle"
		current_relaxed_jog_anim = "Rifle Anims/rifle run"
	return true

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
	equip_weapon(new_gun)

func drop_weapon(weapon_to_drop : Gun):
	print("Dropping: " + weapon_to_drop.name)
	weapon_to_drop.queue_free()
