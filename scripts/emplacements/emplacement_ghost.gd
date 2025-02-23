class_name EmplacementGhost
extends Node3D

@export var models : Array[GeometryInstance3D]

@onready var emplacement_overlapper = %EmplacementOverlapper

const BLUEPRINT_GHOST_MAT = preload("res://materials/blueprint_ghost_mat.tres")
const BLUEPRINT_GHOST_INVALID_MAT = preload("res://materials/blueprint_ghost_invalid_mat.tres")

var valid_placement := true
var currently_inside = []

func _ready():
	emplacement_overlapper.area_entered.connect(add_overlapping_body)
	emplacement_overlapper.area_exited.connect(remove_overlapping_body)
	emplacement_overlapper.area_shape_entered.connect(_on_emplacement_overlapper_area_shape_entered)
	emplacement_overlapper.area_shape_exited.connect(_on_emplacement_overlapper_area_shape_exited)
	emplacement_overlapper.body_entered.connect(add_overlapping_body)
	emplacement_overlapper.body_exited.connect(remove_overlapping_body)

func add_overlapping_body(body):
	currently_inside.append(body)
	valid_placement = false
	for model in models:
		model.material_override = BLUEPRINT_GHOST_INVALID_MAT

func remove_overlapping_body(body):
	var index = currently_inside.find(body)
	if index != -1:
		currently_inside.remove_at(index)
	if currently_inside.size() == 0:
		valid_placement = true
		for model in models:
			model.material_override = BLUEPRINT_GHOST_MAT

func _on_emplacement_overlapper_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	add_overlapping_body(area)

func _on_emplacement_overlapper_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	remove_overlapping_body(area)
