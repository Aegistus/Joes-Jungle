class_name Player
extends CharacterBody3D

@export var min_damage = 3
@export var max_damage = 6
@export var turn_rate := 5.0
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var animation_player: AnimationPlayer

@onready var pistol = $"PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/PistolHolder/Pistol 92"
@onready var pistol_anim = pistol.get_node("AnimationPlayer") as AnimationPlayer
@onready var raycast = pistol.get_node("gun model/RayCast3D") as RayCast3D
@onready var pistol_92 = $"PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/PistolHolder/Pistol 92"

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("shoot"):
		pistol_anim.play("shoot")
		var collided = raycast.get_collider()
		if collided != null:
			print(collided.name)
		if collided != null and collided.is_in_group("enemy"):
			collided.hit(randi_range(min_damage, max_damage))
		pistol_92.shoot()
