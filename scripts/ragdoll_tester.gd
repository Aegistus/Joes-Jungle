extends Node

@export var spawn_interval = 6

const ZOMBIE = preload("res://scenes/enemies/zombie.tscn")
const TANK_ZOMBIE = preload("res://scenes/enemies/tank_zombie.tscn")
const FAST_ZOMBIE = preload("res://scenes/enemies/fast_zombie.tscn")

var timer

func _ready():
	timer = Timer.new()
	add_child(timer, false, Node.INTERNAL_MODE_FRONT)
	timer.wait_time = spawn_interval
	timer.timeout.connect(spawn_new)
	spawn_new()


func spawn_new():
	for i in get_child_count():
		var zombie = FAST_ZOMBIE.instantiate()
		get_child(i).add_child(zombie)
		zombie.position = Vector3.ZERO
		zombie.rotate(Vector3.UP, 180)
		zombie.hit(1000, Vector3.FORWARD, Vector3.FORWARD)
	timer.start()
