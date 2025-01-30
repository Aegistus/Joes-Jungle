class_name FollowState
extends ZombieState

@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent = $"../../NavigationAgent3D"
@onready var animation_player = $"../../AnimationPlayer"

const WALK_ANIM_COUNT = 3
const ANIM_SPEED_VARIANCE_RANGE = .1

var all_walk_anims = ["Zombie Anims/Zombie Walk", "Zombie Anims/Zombie Walk 2", "Zombie Anims/Zombie Walk 3"]
var anim_speed_scales = [1.5, 2, 1]
var move_speeds = [60, 60, 100]
var anim_index
var anim_speed_variance

func _ready():
	anim_index = randi() % WALK_ANIM_COUNT
	anim_speed_variance = randf() * ANIM_SPEED_VARIANCE_RANGE

func enter():
	super()
	animation_player.play(all_walk_anims[anim_index])
	animation_player.speed_scale = anim_speed_scales[anim_index] + anim_speed_variance

func process_state(delta):
	zombie.velocity = Vector3.ZERO
	nav_agent.set_target_position(player.position)
	var next_nav_point = nav_agent.get_next_path_position()
	zombie.velocity = (next_nav_point - zombie.transform.origin).normalized() * move_speeds[anim_index] * delta
	
	zombie.look_at(Vector3(next_nav_point.x, zombie.position.y, next_nav_point.z))
	
	zombie.move_and_slide()

func exit():
	animation_player.speed_scale = 1
