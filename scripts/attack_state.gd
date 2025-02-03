class_name AttackState
extends ZombieState

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"
@onready var dead_state = $"../DeadState"

var attack_anims = ["Zombie Anims/Zombie Attack 1", "Zombie Anims/Zombie Attack 2", "Zombie Anims/Zombie Attack 3",\
	"Zombie Anims/Zombie Attack 4", "Zombie Anims/Zombie Attack 5", "Zombie Anims/Zombie Attack 6"]
var exit_state = false

const ZOMBIE_ATTACK_ANIM_COUNT = 6

func enter():
	var attack_index = randi() % ZOMBIE_ATTACK_ANIM_COUNT
	animation_player.play(attack_anims[attack_index])
	exit_state = false
	animation_player.animation_finished.connect(func(anim_name): exit_state = true)

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	if exit_state:
		return follow_state
