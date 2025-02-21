class_name HitState
extends ZombieState

@export var body_part_names = ["Head", "LeftUpperArm", "LeftLowerArm", "RightUpperArm", "RightLowerArm"]

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"
@onready var dead_state = $"../DeadState"
@onready var general_skeleton = %GeneralSkeleton as Skeleton3D

var animation_done = false

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
	var body_part : String = body_part_names.pick_random()
	var idx = general_skeleton.find_bone(body_part)
	general_skeleton.set_bone_pose_scale(idx, Vector3.ZERO)

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	if animation_done:
		return follow_state
	else:
		return null
