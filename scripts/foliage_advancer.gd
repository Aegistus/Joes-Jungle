extends Node3D

@export var start_wave := 1
@export var delay := 1

var children_randomized
var skipped : Array[Node3D]
var index = 0
var camera : Camera3D

func _ready():
	for child in get_children():
		child.visible = false
	GameManager.on_wave_start.connect(check_wave)
	children_randomized = get_children()
	children_randomized.shuffle()

func check_wave():
	if GameManager.current_wave >= start_wave:
		advance_foliage()

func advance_foliage():
	while children_randomized.size() > 0:
		if camera == null:
			camera = get_tree().get_first_node_in_group("camera")
		for i in children_randomized.size():
			if not camera.is_position_in_frustum(children_randomized[i].global_position):
				children_randomized[i].visible = true
				children_randomized.remove_at(i)
				break
		await get_tree().create_timer(delay).timeout
