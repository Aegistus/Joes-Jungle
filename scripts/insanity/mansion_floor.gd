extends Node3D

@export var flesh_material : Material

var children

func _ready():
	children = get_children() as Array[CSGBox3D]

func _process(delta):
	flesh_material.albedo_color.a = GameManager.current_insanity
