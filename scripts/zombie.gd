class_name Zombie
extends CharacterBody3D

@export var starting_health = 10
@onready var ragdoll = $zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D
@onready var state_machine = $StateMachine
@onready var hit_state = $StateMachine/HitState

var current_health

func _ready():
	current_health = starting_health
	ragdoll.physical_bones_stop_simulation()

func hit(damage):
	current_health -= damage
	if current_health <= 0:
		current_health = 0
		print("I'm dead")
	else:
		state_machine.transition_to(hit_state)
