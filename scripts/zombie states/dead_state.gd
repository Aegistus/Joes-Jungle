class_name DeadState
extends ZombieState

@export var despawn_delay = 5.0

@onready var ragdoll = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D"
@onready var hip_bone = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D/Physical Bone Hips"
@onready var collision_shape_3d = $"../../CollisionShape3D"
@onready var hitbox = $"../../Hitbox"

func enter():
	hitbox.monitoring = false
	hitbox.queue_free()
	collision_shape_3d.disabled = true
	zombie.velocity = Vector3.ZERO
	randomize()
	var rand_direction = Vector3(randf(), 0, randf()).normalized()
	hip_bone.linear_velocity = Vector3.BACK * 1000
	ragdoll.active = true
	ragdoll.physical_bones_start_simulation()
	var timer = Timer.new()
	self.add_child(timer)
	timer.timeout.connect(zombie.queue_free)
	timer.wait_time = despawn_delay
	timer.start()
	GameManager.add_points(zombie.point_value)
