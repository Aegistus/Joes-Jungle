class_name HitState
extends ZombieState

@export var body_part_names = ["Physical Bone Head", "Physical Bone LeftUpperArm",\
	"Physical Bone LeftLowerArm", "Physical Bone RightUpperArm", "Physical Bone RightLowerArm"]

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"
@onready var dead_state = $"../DeadState"
@onready var general_skeleton = %GeneralSkeleton as Skeleton3D
@onready var bone_simulator = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D" as PhysicalBoneSimulator3D

var already_dismembered_parts = []
var animation_done = false
var physics_bones : Array

func _ready():
	physics_bones = bone_simulator.get_children().filter(func(i): return i as PhysicalBone3D)

func enter():
	animation_done = false
	if randf() > .5:
		animation_player.play("Zombie Anims/Zombie Hit 1")
		animation_player.seek(.3)
	else:
		animation_player.play("Zombie Anims/Zombie Hit 2")
		animation_player.seek(.4)
	zombie.velocity = Vector3.ZERO
	animation_player.animation_finished.connect(func(anim_name): animation_done = true)
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
	for bone in bones_to_remove:
		var bone_transform = general_skeleton.get_bone_global_pose(bone.get_bone_id())
		general_skeleton.set_bone_pose_scale(bone.get_bone_id(), Vector3.ONE * .001)
		#general_skeleton.set_bone_global_pose_override(bone.get_bone_id(), bone_transform.scaled(Vector3.ONE * .001), 1.0, true)	
		already_dismembered_parts.append(bone.get_bone_id())
		bone.collision_layer = 0
		bone.collision_mask = 0
		bone.get_parent().remove_child(bone)
		bone.queue_free()
		physics_bones.erase(bone)
	#print("Done dismembering")

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	if animation_done:
		return follow_state
	else:
		return null
