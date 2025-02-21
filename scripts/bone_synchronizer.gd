extends PhysicalBoneSimulator3D

@onready var general_skeleton = %GeneralSkeleton

var physics_bones : Array

func _ready():
	physics_bones = get_children().filter(func(i): return i as PhysicalBone3D)

func _physics_process(delta):
	if !active:
		for bone in physics_bones:
			var bone_offset : Transform3D = bone.get("body_offset")
			var bone_global_transform = self.global_transform * general_skeleton.get_bone_global_pose(bone.get_bone_id())
			bone.global_transform = bone_global_transform * bone_offset
