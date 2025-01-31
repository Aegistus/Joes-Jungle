class_name Player
extends CharacterBody3D

@export var turn_rate := 5.0
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var animation_player: AnimationPlayer

@onready var pistol = $"PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/PistolHolder/Pistol 92"
@onready var pistol_anim = pistol.get_node("AnimationPlayer") as AnimationPlayer

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
