class_name HitState
extends ZombieState

@export var dismember_chance = .3

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"
@onready var dead_state = $"../DeadState"
@onready var general_skeleton = %GeneralSkeleton as Skeleton3D
@onready var bone_simulator = $"../../zombie_model/Armature/GeneralSkeleton/PhysicalBoneSimulator3D" as PhysicalBoneSimulator3D

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
	if randf() <= dismember_chance && zombie.allow_dismember:
		zombie.random_dismember()

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	if animation_done:
		return follow_state
	else:
		return null
