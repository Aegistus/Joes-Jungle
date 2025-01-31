class_name DeadState
extends ZombieState

@onready var ragdoll = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D"

func enter():
	zombie.velocity = Vector3.ZERO
	ragdoll.active = true
	ragdoll.physical_bones_start_simulation()
