extends Skeleton3D

@export var allowed_bones : Array[String] = ["Head", "Chest", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"]

var min_scale_change = -.5
var max_scale_change = .5
var min_bones_changed = 0
var max_bones_changed = 10

func _ready():
	var num_of_bones_changed = randi_range(min_bones_changed, max_bones_changed)
	for i in num_of_bones_changed:
		var bone = find_bone(allowed_bones.pick_random())
		var random_scale = randf_range(min_scale_change, max_scale_change)
		random_scale *= GameManager.current_insanity
		set_bone_pose_scale(bone, Vector3(1 + random_scale, 1 + random_scale, 1 + random_scale))
