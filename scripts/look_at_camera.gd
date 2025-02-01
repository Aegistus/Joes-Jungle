extends Node3D

var camera

func _ready():
	camera = get_tree().get_first_node_in_group("camera")

func _process(delta):
	look_at(camera.global_position)
