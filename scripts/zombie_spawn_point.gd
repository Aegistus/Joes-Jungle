extends Node3D

@export var initial_delay = 3.0
@export var wave_delay = 30.0

@onready var wave_timer = $WaveTimer
@onready var spawn_timer = $SpawnTimer
@onready var spawn_point_parent = $SpawnPointParent

var current_wave_spawn_count = 5
var all_spawn_points
var spawn_point_count

const MAX_ZOMBIES = 100
const ZOMBIE_SCENE = preload("res://scenes/zombie.tscn")

func _ready():
	wave_timer.wait_time = initial_delay
	wave_timer.start()
	all_spawn_points = spawn_point_parent.get_children() as Array[Node3D]
	spawn_point_count = all_spawn_points.size()

func _on_timer_timeout():
	spawn_wave()

func spawn_wave():
	var all_zombies = get_tree().get_nodes_in_group("enemy")
	for i in range(0, current_wave_spawn_count):
		all_zombies = get_tree().get_nodes_in_group("enemy")
		if all_zombies.size() < MAX_ZOMBIES:
			var zombie = ZOMBIE_SCENE.instantiate()
			get_parent_node_3d().add_child(zombie)
			zombie.position = all_spawn_points[i % spawn_point_count].position
		spawn_timer.wait_time = .1
		spawn_timer.start()
		await spawn_timer.timeout
	current_wave_spawn_count += 1
	wave_timer.wait_time = wave_delay
	wave_timer.start()
