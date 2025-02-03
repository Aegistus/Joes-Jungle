extends Node3D

@export var initial_delay = 3.0
@export var spawn_delay = 15
@export var delay_decrease = 1
@export var min_spawn_delay = 5

@onready var timer = $Timer

const MAX_ZOMBIES = 100

var current_delay
const ZOMBIE_SCENE = preload("res://scenes/zombie.tscn")

func _ready():
	current_delay = spawn_delay
	timer.wait_time = initial_delay
	timer.start()
	

func _on_timer_timeout():
	var all_zombies = get_tree().get_nodes_in_group("enemy")
	if all_zombies.size() < MAX_ZOMBIES:
		var zombie = ZOMBIE_SCENE.instantiate()
		get_parent_node_3d().add_child(zombie)
		zombie.position = position
		current_delay = clampf(current_delay - delay_decrease, 1, 1000)
	timer.wait_time = current_delay
	timer.start()
