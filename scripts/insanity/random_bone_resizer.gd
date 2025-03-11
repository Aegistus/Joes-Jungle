extends Skeleton3D

@export var allowed_bones : Array[String] = ["Head", "Chest", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"]

var min_scale_change = -.75
var max_scale_change = .75

func _ready():
	var bone = find_bone(allowed_bones.pick_random())
	var random_scale = randf_range(min_scale_change, max_scale_change)
	random_scale *= GameManager.current_insanity
	set_bone_pose_scale(bone, Vector3(1 + random_scale, 1 + random_scale, 1 + random_scale))
