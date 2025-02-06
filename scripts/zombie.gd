class_name Zombie
extends CharacterBody3D

@export var starting_health = 10
@export var point_value = 10
@onready var ragdoll = $zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D
@onready var state_machine = $StateMachine
@onready var hit_state = $StateMachine/HitState

@onready var blood_particle_scene = preload("res://scenes/particles/blood_particles.tscn")

var current_health

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
	else:
		state_machine.transition_to(hit_state)
