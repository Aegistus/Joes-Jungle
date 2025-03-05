extends Node3D

@export var fade_distance := 8.0
@export var fade_time := .5

var camera
var children
var hidden = false

func _ready():
	camera = get_tree().get_first_node_in_group("camera")
	children = get_children()

func _process(delta):
	if camera == null:
		camera = get_tree().get_first_node_in_group("camera")
	else:
		if global_position.distance_squared_to(camera.global_position) < pow(fade_distance, 2):
			if !hidden:
				hidden = true
				for child in children:
					var tween = get_tree().create_tween()
					tween.tween_property(child, "transparency", 1, fade_time)
					#child.visible = false
		elif hidden == true:
			hidden = false
			for child in children:
				var tween = get_tree().create_tween()
				tween.tween_property(child, "transparency", 0, fade_time)
				#child.visible = true
