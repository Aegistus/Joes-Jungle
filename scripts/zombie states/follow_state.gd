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

var anim_index
var anim_speed_variance
var follow_target

func _ready():
	anim_index = randi() % all_walk_anims.size()
	anim_speed_variance = randf() * ANIM_SPEED_VARIANCE_RANGE

func enter():
	super()
	animation_player.play(all_walk_anims[anim_index])
	animation_player.speed_scale = anim_speed_scales[anim_index] + anim_speed_variance

func process_state(delta):
	if player:
		nav_agent.set_target_position(player.position)
		if not nav_agent.is_target_reachable() and zombie.target_barricade == null:
			var barricades = get_tree().get_nodes_in_group("barricade")
			var closest = 999999999
			for b in barricades:
				var sq_dist = zombie.global_position.distance_squared_to(b.global_position)
				if sq_dist < closest:
					closest = sq_dist
					zombie.target_barricade = b
		if zombie.target_barricade:
			follow_target = zombie.target_barricade
		else:
			follow_target = player
		zombie.velocity = Vector3.ZERO
		nav_agent.set_target_position(follow_target.position)
		var next_nav_point = nav_agent.get_next_path_position()
		nav_agent.get_path()
		zombie.velocity = (next_nav_point - zombie.transform.origin).normalized() * move_speeds[anim_index] * delta
		zombie.velocity *= zombie.speed_modifier
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
	animation_player.speed_scale = 1
