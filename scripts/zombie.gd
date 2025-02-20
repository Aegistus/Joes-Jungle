class_name Zombie
extends CharacterBody3D

@export var starting_health = 10
@export var point_value = 10
@export var stagger_immune = false

@onready var ragdoll = $zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D
@onready var state_machine = $StateMachine
@onready var hit_state = $StateMachine/HitState

@onready var blood_particle_scene = preload("res://scenes/particles/blood_particles.tscn")

var is_alive:
	get:
		return current_health > 0

var current_health
var target_barricade : BarricadeEmplacement:
	set(value):
		target_barricade = value
		if value != null:
			value.on_destroy.connect(func(): target_barricade = null)

func _ready():
	current_health = starting_health
	ragdoll.physical_bones_stop_simulation()

func hit(damage, position : Vector3, hit_direction : Vector3):
	current_health -= damage
	var blood = blood_particle_scene.instantiate() as GPUParticles3D
	add_child(blood)
	blood.global_position = position
	blood.rotation_degrees = hit_direction
	blood.emitting = true
	if current_health <= 0:
		current_health = 0
		print("I'm dead")
	elif not stagger_immune:
		state_machine.transition_to(hit_state)

# quick damage that doesn't cause stagger or blood
func quick_hit(damage):
	current_health -= damage
	if current_health <= 0:
		current_health = 0

func barricade_detected(area : Area3D):
	target_barricade = area.get_parent()
