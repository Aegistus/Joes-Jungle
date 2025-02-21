class_name Zombie
extends CharacterBody3D

@export var starting_health = 10
@export var point_value = 10
@export var stagger_immune = false
@export var body_part_names = ["Physical Bone Head", "Physical Bone LeftUpperArm",\
	"Physical Bone LeftLowerArm", "Physical Bone RightUpperArm", "Physical Bone RightLowerArm"]

@onready var ragdoll = $zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D
@onready var state_machine = $StateMachine
@onready var hit_state = $StateMachine/HitState
@onready var general_skeleton = %GeneralSkeleton
@onready var blood_particle_scene = preload("res://scenes/particles/blood_particles.tscn")

const LIMB_EXPLOSION_PARTICLES = preload("res://scenes/particles/limb_explosion_particles.tscn")
const BLOOD_SPRAY_PARTICLES = preload("res://scenes/particles/blood_spray_particles.tscn")

var physics_bones : Array
var is_alive:
	get:
		return current_health > 0
var current_health
var target_barricade : BarricadeEmplacement:
	set(value):
		target_barricade = value
		if value != null:
			value.on_destroy.connect(func(): target_barricade = null)
var already_dismembered_parts = []

func _ready():
	current_health = starting_health
	ragdoll.physical_bones_stop_simulation()
	physics_bones = ragdoll.get_children().filter(func(i): return i as PhysicalBone3D)

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

func random_dismember():
	var body_part_name : String = body_part_names.pick_random()
	var parent_bone : PhysicalBone3D
	for b in physics_bones:
		if b.name == body_part_name:
			parent_bone = b
	var child_bone_ids = general_skeleton.get_bone_children(parent_bone.get_bone_id())
	var bones_to_remove = [parent_bone]
	for child_bone in physics_bones:
		for child_bone_id in child_bone_ids:
			if child_bone.get_bone_id() == child_bone_id:
				bones_to_remove.append(child_bone)
	# add explosion particle effects
	var explosion_particles = LIMB_EXPLOSION_PARTICLES.instantiate()
	get_tree().root.add_child(explosion_particles)
	explosion_particles.global_position = parent_bone.global_position
	#var blood_spray = BLOOD_SPRAY_PARTICLES.instantiate()
	#parent_bone.get_parent().add_child(blood_spray)
	#blood_spray.global_position = parent_bone.global_position
	#%DeadState.on_zombie_death.connect(func(): blood_spray.queue_free()) # remove blood spray on death
	for bone in bones_to_remove:
		var bone_transform = general_skeleton.get_bone_global_pose(bone.get_bone_id())
		#general_skeleton.set_bone_pose_scale(bone.get_bone_id(), Vector3.ONE * .0001)
		general_skeleton.set_bone_global_pose_override(bone.get_bone_id(), bone_transform.scaled(Vector3.ONE * .0001), 1.0, true)	
		already_dismembered_parts.append(bone.get_bone_id())
		bone.collision_layer = 0
		bone.collision_mask = 0
		bone.get_parent().remove_child(bone)
		bone.queue_free()
		physics_bones.erase(bone)
	#print("Done dismembering")
