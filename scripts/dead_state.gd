class_name DeadState
extends ZombieState

@onready var ragdoll = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D"
@onready var hip_bone = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D/Physical Bone Hips"
@onready var collision_shape_3d = $"../../CollisionShape3D"

func enter():
	collision_shape_3d.disabled = true
	zombie.velocity = Vector3.ZERO
	hip_bone.linear_velocity = Vector3.BACK * 10
	ragdoll.active = true
	ragdoll.physical_bones_start_simulation()
