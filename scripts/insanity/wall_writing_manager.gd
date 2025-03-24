extends Node3D

var children_decals : Array[Decal]
var children_collisions : Array[CollisionShape3D]
var set_monitorable = false

const DECAL_START_FADE = 300
const DECAL_END_FADE = .3
const PERCENT_INSANITY_FULLY_VISIBLE = .25

func _ready():
	var all_children = get_all_children(self)
	for child in all_children:
		if child is Decal:
			children_decals.append(child)
		if child is CollisionShape3D:
			children_collisions.append(child)
	for decal in children_decals:
		decal.upper_fade = 300
		decal.lower_fade = 300
	for area in children_collisions:
		area.disabled = true

func _process(delta):
	for decal in children_decals:
		decal.upper_fade = lerpf(DECAL_START_FADE, DECAL_END_FADE, GameManager.current_linear_insanity / PERCENT_INSANITY_FULLY_VISIBLE)
		decal.lower_fade = lerpf(DECAL_START_FADE, DECAL_END_FADE, GameManager.current_linear_insanity / PERCENT_INSANITY_FULLY_VISIBLE)
	if !set_monitorable and GameManager.current_linear_insanity > PERCENT_INSANITY_FULLY_VISIBLE:
		set_monitorable = true
		for area in children_collisions:
			area.disabled = false

func get_all_children(node) -> Array:
	var nodes : Array = []
	for n in node.get_children():
		nodes.append(n)
		if n.get_child_count() > 0:
			nodes.append_array(get_all_children(n))
	return nodes
