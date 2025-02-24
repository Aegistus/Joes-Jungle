extends DeadState

@onready var boomer_explosion = $"../../BoomerExplosion"
@onready var zombie_model = $"../../zombie_model"
@onready var body_parts = $"../../BodyParts"
@onready var physical_bone_sim_left_arm = $"../../BodyParts/Boomer Zombie Left Arm/Armature/Skeleton3D/PhysicalBoneSimLeftArm"
@onready var physical_bone_sim_legs = $"../../BodyParts/Boomer Zombie Legs/Armature/Skeleton3D/PhysicalBoneSimLegs"
@onready var physical_bone_sim_right_arm = $"../../BodyParts/Boomer Zombie Right Arm/Armature/Skeleton3D/PhysicalBoneSimRightArm"
@onready var zombie_head = $"../../BodyParts/ZombieHead"

func enter():
	body_parts.visible = true
	zombie_head.sleeping = false
	physical_bone_sim_left_arm.physical_bones_start_simulation()
	physical_bone_sim_right_arm.physical_bones_start_simulation()
	physical_bone_sim_legs.physical_bones_start_simulation()
	boomer_explosion.emit()
	zombie_model.visible = false
	super()
