extends Node3D

@onready var breathing_audio_player = $BreathingAudioPlayer

const BRICK_WALL_MAT = preload("res://materials/brick_wall_mat.tres")

var max_size_increase = .2
var children

func _ready():
	children = get_children() as Array[CSGBox3D]

func _process(delta):
	var size_increase = GameManager.current_insanity * max_size_increase * sin(GameManager.run_time) + GameManager.current_insanity * max_size_increase
	for child in children:
		if child is CSGBox3D:
			var scale = Vector3((child.size.x + size_increase) / child.size.x, 1, (child.size.z + size_increase) / child.size.z)
			child.scale = scale
	breathing_audio_player.volume_db = (1 - GameManager.current_insanity) * -80 + 40 * GameManager.current_insanity
	BRICK_WALL_MAT.set_shader_parameter("alpha", 1 - GameManager.current_insanity)
