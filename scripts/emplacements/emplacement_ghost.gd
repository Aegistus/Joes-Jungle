class_name EmplacementGhost
extends Node3D

@export var models : Array[GeometryInstance3D]

@onready var emplacement_overlapper = %EmplacementOverlapper

const BLUEPRINT_GHOST_MAT = preload("res://materials/blueprint_ghost_mat.tres")
const BLUEPRINT_GHOST_INVALID_MAT = preload("res://materials/blueprint_ghost_invalid_mat.tres")

var valid_placement := true
var currently_inside = []

func _on_emplacement_overlapper_area_entered(area):
	currently_inside.append(area)
	valid_placement = false
	for model in models:
		model.material_override = BLUEPRINT_GHOST_INVALID_MAT

func _on_emplacement_overlapper_area_exited(area):
	var index = currently_inside.find(area)
	if index != -1:
		currently_inside.remove_at(index)
	if currently_inside.size() == 0:
		valid_placement = true
		for model in models:
			model.material_override = BLUEPRINT_GHOST_MAT
