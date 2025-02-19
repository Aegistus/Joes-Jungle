extends Node3D

class SpawnEntry:
	var prototype
	var spawn_weight
	var starting_wave = 0
	
	func _init(prototype, spawn_weight, starting_wave):
		self.prototype = prototype
		self.spawn_weight = spawn_weight
		self.starting_wave = starting_wave

@export var starting_wave_delay = 3
@export var starting_enemy_count = 10
@export var enemy_count_increase_per_wave = 5
@export var intermission_wait_time = 10.0
@export var intermission_increase = 5.0
@export var intermission_max = 60.0
@export_group("Enemies")
@export var fast_zombie_spawn_start = 5
@export var tank_zombie_spawn_start = 8

@onready var intermission_timer = $IntermissionTimer
@onready var spawn_timer = $SpawnTimer
@onready var spawn_point_parent = $SpawnPointParent as Node3D

var current_wave = 0
var wave_completed = true
var current_enemy_count = starting_enemy_count
var all_spawn_points
@onready var zombie_spawn_table = [
	SpawnEntry.new(FAST_ZOMBIE, 10, fast_zombie_spawn_start),
	SpawnEntry.new(TANK_ZOMBIE, 10, tank_zombie_spawn_start),
	SpawnEntry.new(ZOMBIE, 80, 0),
]
var sum_of_spawn_weights : int

const MAX_ZOMBIES = 100
const ZOMBIE = preload("res://scenes/enemies/zombie.tscn")
const FAST_ZOMBIE = preload("res://scenes/enemies/fast_zombie.tscn")
const TANK_ZOMBIE = preload("res://scenes/enemies/tank_zombie.tscn")

func _ready():
	all_spawn_points = spawn_point_parent.get_children() as Array[Node3D]
	for i in zombie_spawn_table.size():
		sum_of_spawn_weights += zombie_spawn_table[i].spawn_weight
	intermission_timer.wait_time = starting_wave_delay
	intermission_timer.one_shot = true
	intermission_timer.start()
	intermission_timer.timeout.connect(spawn_next_wave)
	GameManager.on_zombie_kill.connect(check_for_wave_end)

func spawn_next_wave():
	wave_completed = false
	current_wave += 1
	GameManager.on_wave_start.emit()
	print("Wave start: " + str(current_wave))
	all_spawn_points.shuffle()
	var all_zombies_count = get_tree().get_nodes_in_group("enemy").size()
	for i in current_enemy_count:
		if all_zombies_count < MAX_ZOMBIES:
			spawn_zombie(i)
			all_zombies_count += 1
			spawn_timer.wait_time = .2
			spawn_timer.start()
			await spawn_timer.timeout
	current_enemy_count += enemy_count_increase_per_wave
	intermission_wait_time = clampf(intermission_wait_time + intermission_increase, 0, intermission_max)

func spawn_zombie(spawn_index : int):
	var zombie_prototype
	var sum_of_weight = sum_of_spawn_weights
	var rnd = randf_range(0, sum_of_weight)
	print(rnd)
	for table in zombie_spawn_table:
		if rnd < table.spawn_weight and current_wave >= table.starting_wave:
			zombie_prototype = table.prototype
			break
		rnd -= table.spawn_weight
	var spawned_zombie = zombie_prototype.instantiate()
	get_parent_node_3d().add_child(spawned_zombie)
	spawned_zombie.position = all_spawn_points[spawn_index % all_spawn_points.size()].position

func check_for_wave_end():
	if wave_completed:
		return
	var all_zombies = get_tree().get_nodes_in_group("enemy")
	for zombie : Zombie in all_zombies:
		if zombie.is_alive:
			return
	wave_completed = true
	GameManager.on_wave_end.emit()
	print("Wave completed")
	start_intermission()

func start_intermission():
	intermission_timer.wait_time = intermission_wait_time
	intermission_timer.start()
