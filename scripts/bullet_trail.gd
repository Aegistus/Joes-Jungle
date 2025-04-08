extends Node3D

@export var speed := 100.0 # m/s
@export var tracer_length := 1.0

var target_position : Vector3

const MAX_LIFETIME = 5.0

@onready var spawn_time = Time.get_ticks_msec()

func _ready():
	%DespawnTimer.wait_time = MAX_LIFETIME
	%DespawnTimer.timeout.connect(func(): queue_free())

func _process(delta):
	look_at(target_position)
	var travel_distance = target_position - self.global_position
	var displacement = travel_distance.normalized() * speed * delta
	if (travel_distance).length_squared() <= pow(tracer_length, 2):
		queue_free()
	else:
		displacement = displacement.limit_length(travel_distance.length())
		global_position += displacement
