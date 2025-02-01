class_name Player
extends CharacterBody3D

@export var min_damage = 3
@export var max_damage = 6
@export var turn_rate := 5.0
@export var water_rate = 30.0
@export var directional_reference: Node3D
@export var player_model: Node3D
@export var animation_player: AnimationPlayer

@onready var pistol = $"PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/PistolHolder/Pistol 92"
@onready var raycast = pistol.get_node("gun model/RayCast3D") as RayCast3D
@onready var pistol_92 = $"PlayerModel/Model/Armature/GeneralSkeleton/BoneAttachment3D/PistolHolder/Pistol 92"
@onready var interact_raycast = $PlayerModel/InteractRaycast

var current_plant

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var plant = interact_raycast.get_collider()
	if plant != null:
		if plant.is_in_group("plant"):
			print("plant found")
			current_plant = plant.get_node("../../WateringBush") as WateringBush
	else:
		current_plant = null
	
	if Input.is_action_pressed("interact") and current_plant != null:
		current_plant.water(water_rate * delta)
