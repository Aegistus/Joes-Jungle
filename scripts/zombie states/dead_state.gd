class_name DeadState
extends ZombieState

signal on_zombie_death

@export var despawn_delay = 5.0

@onready var ragdoll = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D"
@onready var hip_bone = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D/Physical Bone Hips"
@onready var collision_shape_3d = $"../../CollisionShape3D"
@onready var hitbox = $"../../Hitbox"
@onready var hit_state = %HitState
@onready var general_skeleton : Skeleton3D = %GeneralSkeleton

func enter():
	hitbox.monitoring = false
	hitbox.queue_free()
	collision_shape_3d.disabled = true
	zombie.velocity = Vector3.ZERO
	ragdoll.active = true
	ragdoll.physical_bones_start_simulation()
	for bone in zombie.already_dismembered_parts:
		general_skeleton.set_bone_pose_scale(bone, Vector3.ONE * .00001)
		remove_all_child_bones(bone)
		#var bone_transform = general_skeleton.get_bone_global_pose(bone)
		#general_skeleton.set_bone_global_pose_override(bone, bone_transform.scaled(Vector3.ONE * .0001), 1.0, true)
	var rand_direction = Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1).normalized()
	hip_bone.linear_velocity = rand_direction * 20
	var timer = Timer.new()
	self.add_child(timer)
	timer.timeout.connect(zombie.queue_free)
	timer.wait_time = despawn_delay
	timer.start()
	zombie.remove_from_group("enemy")
	GameManager.add_points(randi_range(zombie.min_point_value, zombie.max_point_value))
	GameManager.add_to_killstreak()
	GameManager.on_zombie_kill.emit()
	on_zombie_death.emit()

func remove_all_child_bones(parent : int):
	var children = general_skeleton.get_bone_children(parent)
	for i in children.size():
		remove_all_child_bones(children[i])
		general_skeleton.set_bone_pose_scale(children[i], Vector3.ONE * .00001)
