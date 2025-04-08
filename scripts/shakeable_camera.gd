class_name ShakeableCamera
extends Area3D

@export var shake_reduction_rate := 1.0
@export var noise : Noise
@export var noise_speed := 50.0
@export var max_degrees := Vector3(10.0, 10.0, 5.0)

var shake_intensity := 0.0
var elapsed_time := 0.0

@onready var camera := %Camera
@onready var initial_rotation := camera.rotation_degrees as Vector3
@onready var directional_reference = %DirectionalReference

func _process(delta):
	elapsed_time += delta
	shake_intensity = max(shake_intensity - delta * shake_reduction_rate, 0.0)
	
	camera.rotation_degrees.x = initial_rotation.x + max_degrees.x * pow(shake_intensity, 2) * get_noise_from_seed(0)
	camera.rotation_degrees.y = initial_rotation.y + max_degrees.y * pow(shake_intensity, 2) * get_noise_from_seed(1)
	camera.rotation_degrees.z = initial_rotation.z + max_degrees.z * pow(shake_intensity, 2) * get_noise_from_seed(2)

func add_screen_shake(shake_amount : float):
	shake_intensity = clamp(shake_intensity + shake_amount, 0.0, 1.0)

func get_noise_from_seed(seed : int) -> float:
	noise.seed = seed
	return noise.get_noise_1d(elapsed_time * noise_speed)
