extends Node3D

@export var initial_delay = 3.0
@export var wave_delay = 30.0
@export var fast_zombie_delay = 120
@export var tank_zombie_delay = 300
@export var fast_zombie_spawn_chance = 10
@export var tank_zombie_spawn_chance = 10

@onready var wave_timer = $WaveTimer
@onready var spawn_timer = $SpawnTimer
@onready var spawn_point_parent = $SpawnPointParent

var current_wave_spawn_count = 8
var all_spawn_points
var spawn_point_count

const MAX_ZOMBIES = 100
const ZOMBIE_SCENE = preload("res://scenes/enemies/zombie.tscn")
const FAST_ZOMBIE_SCENE = preload("res://scenes/enemies/fast_zombie.tscn")
const TANK_ZOMBIE_SCENE = preload("res://scenes/enemies/tank_zombie.tscn")

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
		if all_zombies.size() < MAX_ZOMBIES: # if below max zombie threshold
			var spawn_type_chance = randf_range(0, 100)
			var zombie
			if spawn_type_chance < fast_zombie_spawn_chance and GameManager.run_time > fast_zombie_delay:
				zombie = FAST_ZOMBIE_SCENE.instantiate()
			else:
				spawn_type_chance -= fast_zombie_spawn_chance
				if spawn_type_chance < tank_zombie_spawn_chance and GameManager.run_time > tank_zombie_delay:
					zombie = TANK_ZOMBIE_SCENE.instantiate()
				else:
					zombie = ZOMBIE_SCENE.instantiate()
			get_parent_node_3d().add_child(zombie)
			zombie.position = all_spawn_points[i % spawn_point_count].position
		spawn_timer.wait_time = .1
		spawn_timer.start()
		await spawn_timer.timeout
	current_wave_spawn_count += 3
	wave_timer.wait_time = wave_delay
	wave_timer.start()
