class_name BuildConstructState
extends PlayerState

@onready var aim_state_machine = %AimStateMachine

var build_anims = ["Michael Build/build_construct_01", "Michael Build/build_construct_02", "Michael Build/build_construct_03"]
var finished = false

func enter():
	finished = false
	controlled_player.current_animation_tree.active = false
	controlled_player.animation_player.play(build_anims.pick_random())
	controlled_player.animation_player.animation_finished.connect(func(name): finished = true)

func process_state_physics(delta):
	# handle shooting
	if aim_state_machine.current_state is AimingState:
		if Input.is_action_just_pressed("shoot"):
			controlled_player.gun.shoot()
		if Input.is_action_just_released("shoot"):
			controlled_player.gun.shoot_end()
		if controlled_player.gun.gun_type == Gun.GunType.BUILDGUN:
			if Input.is_action_just_pressed("build_rotate_left"):
				controlled_player.gun.rotate_left()
			if Input.is_action_just_pressed("build_rotate_right"):
				controlled_player.gun.rotate_right()

func exit():
	controlled_player.current_animation_tree.active = true

func check_transitions():
	if finished:
		return %IdleState
	if Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		return %WalkingState
