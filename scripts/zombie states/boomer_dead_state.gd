extends DeadState

@export var ragdoll_bones : Array[PhysicalBone3D]
@export var min_velocity := 10
@export var max_velocity := 20
@export var rotation_randomization := .1

@onready var boomer_explosion = $"../../BoomerExplosion"
@onready var zombie_model = $"../../zombie_model"
@onready var body_parts = $"../../BodyParts"
@onready var physical_bone_sim_left_arm = $"../../BodyParts/Boomer Zombie Left Arm/Armature/Skeleton3D/PhysicalBoneSimLeftArm"
@onready var physical_bone_sim_legs = $"../../BodyParts/Boomer Zombie Legs/Armature/Skeleton3D/PhysicalBoneSimLegs"
@onready var physical_bone_sim_right_arm = $"../../BodyParts/Boomer Zombie Right Arm/Armature/Skeleton3D/PhysicalBoneSimRightArm"
@onready var zombie_head = $"../../BodyParts/ZombieHead"
@onready var explosion_hitbox = $"../../ExplosionHitbox"

var explosion_active_time := .1

func enter():
	body_parts.visible = true
	zombie_head.sleeping = false
	var head_dir = boomer_explosion.global_position.direction_to(zombie_head.global_position)
	head_dir += Vector3(randf_range(-rotation_randomization, rotation_randomization), randf_range(-rotation_randomization, rotation_randomization), randf_range(-rotation_randomization, rotation_randomization))
	head_dir = head_dir.normalized()
	var head_velocity = randf_range(min_velocity, max_velocity) * head_dir
	zombie_head.linear_velocity = head_velocity
	physical_bone_sim_left_arm.physical_bones_start_simulation()
	physical_bone_sim_right_arm.physical_bones_start_simulation()
	physical_bone_sim_legs.physical_bones_start_simulation()
	boomer_explosion.emit()
	zombie_model.visible = false
	for bone in ragdoll_bones:
		var direction = boomer_explosion.global_position.direction_to(bone.global_position)
		direction += Vector3(randf_range(-rotation_randomization, rotation_randomization), randf_range(-rotation_randomization, rotation_randomization), randf_range(-rotation_randomization, rotation_randomization))
		direction = direction.normalized()
		var velocity = randf_range(min_velocity, max_velocity) * direction
		bone.linear_velocity = velocity
	# explosion hitbox
	super()
	explosion_hitbox.monitoring = true
	await get_tree().create_timer(explosion_active_time).timeout
	explosion_hitbox.monitoring = false
