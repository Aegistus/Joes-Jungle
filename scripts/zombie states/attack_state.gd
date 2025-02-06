class_name AttackState
extends ZombieState

@export var attack_anims : Array[String] = ["Zombie Anims/Zombie Attack 1", "Zombie Anims/Zombie Attack 2", "Zombie Anims/Zombie Attack 3",\
	"Zombie Anims/Zombie Attack 4", "Zombie Anims/Zombie Attack 5", "Zombie Anims/Zombie Attack 6"]

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"
@onready var dead_state = $"../DeadState"

var exit_state = false

func enter():
	var attack_index = randi() % attack_anims.size()
	animation_player.play(attack_anims[attack_index])
	exit_state = false
	animation_player.animation_finished.connect(func(anim_name): exit_state = true)

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	if exit_state:
		return follow_state
