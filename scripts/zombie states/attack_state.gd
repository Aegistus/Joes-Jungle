class_name AttackState
extends ZombieState

@export var look_at_player = false
@export var attack_speed_multiplier = 1.5
@export var animation_skip_amount = 0.0
@export var attack_anims : Array[String] = ["Zombie Anims/Zombie Attack 1", "Zombie Anims/Zombie Attack 2", "Zombie Anims/Zombie Attack 3",\
	"Zombie Anims/Zombie Attack 4", "Zombie Anims/Zombie Attack 5", "Zombie Anims/Zombie Attack 6"]

@onready var animation_player = $"../../AnimationPlayer"
@onready var follow_state = $"../FollowState"
@onready var dead_state = $"../DeadState"
@onready var player = get_tree().get_first_node_in_group("player")

var exit_state = false

func enter():
	var attack_index = randi() % attack_anims.size()
	animation_player.speed_scale = attack_speed_multiplier
	animation_player.play(attack_anims[attack_index])
	animation_player.seek(animation_skip_amount, true)
	exit_state = false
	animation_player.animation_finished.connect(func(anim_name): exit_state = true)

func process_state(delta):
	if look_at_player:
		zombie.look_at(player.position)
		

func exit():
	animation_player.speed_scale = 1

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	if exit_state:
		return follow_state
