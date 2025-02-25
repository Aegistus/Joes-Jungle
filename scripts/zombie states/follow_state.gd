class_name FollowState
extends ZombieState

@export var attack_distance = 1.0
@export var dead_state: State
@export var all_walk_anims = ["Zombie Anims/Zombie Walk", "Zombie Anims/Zombie Walk 2", "Zombie Anims/Zombie Walk 3"]
@export var anim_speed_scales : Array[float] = [1.5, 2, 1]
@export var move_speeds = [60, 60, 100]

@onready var no_target_state = $"../NoTargetState"
@onready var attack_state = $"../AttackState"
@onready var player = get_tree().get_first_node_in_group("player")
@onready var nav_agent = $"../../NavigationAgent3D"
@onready var animation_player = $"../../AnimationPlayer"

const ANIM_SPEED_VARIANCE_RANGE = .1
const RECALCULATE_PATH_DISTANCE = 10

var anim_index
var anim_speed_variance
var follow_target
var navigation_timer : Timer
var navigation_delay = .5
var in_state = false
var next_nav_point : Vector3

func _ready():
	navigation_timer = Timer.new()
	add_child(navigation_timer)
	navigation_timer.wait_time = navigation_delay
	navigation_timer.timeout.connect(func(): process_navigation(navigation_delay))
	navigation_timer.start()
	anim_index = randi() % all_walk_anims.size()
	anim_speed_variance = randf() * ANIM_SPEED_VARIANCE_RANGE

func enter():
	super()
	in_state = true
	animation_player.play(all_walk_anims[anim_index])
	animation_player.speed_scale = anim_speed_scales[anim_index] + anim_speed_variance

func process_navigation(delta):
	if in_state and player:
		nav_agent.set_target_position(player.position)
		if zombie.target_barricade == null and not nav_agent.is_target_reachable():
			var barricades = get_tree().get_nodes_in_group("barricade")
			var closest = 999999999
			for b : BarricadeEmplacement in barricades:
				var sq_dist = zombie.global_position.distance_squared_to(b.global_position)
				if sq_dist < closest && b.current_health > 0:
					closest = sq_dist
					zombie.target_barricade = b
		if zombie.target_barricade:
			follow_target = zombie.target_barricade
		else:
			follow_target = player
		zombie.velocity = Vector3.ZERO
		nav_agent.set_target_position(follow_target.position)
		next_nav_point = nav_agent.get_next_path_position()

func process_state_physics(delta):
		zombie.velocity = zombie.speed_modifier * move_speeds[anim_index] * delta * (next_nav_point - zombie.transform.origin).normalized()
		if zombie.position != next_nav_point:
			zombie.look_at(Vector3(next_nav_point.x, zombie.position.y, next_nav_point.z))
		zombie.move_and_slide()

func check_transitions():
	if zombie.current_health <= 0:
		return dead_state
	elif player == null:
		return no_target_state
	elif zombie.target_barricade != null and zombie.global_position.distance_squared_to(zombie.target_barricade.global_position) < pow(attack_distance, 2.0):
		return attack_state
	elif zombie.global_position.distance_squared_to(player.global_position) < pow(attack_distance, 2.0):
		return attack_state
	else:
		return null

func exit():
	in_state = false
	animation_player.speed_scale = 1
