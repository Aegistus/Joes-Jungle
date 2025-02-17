class_name Emplacement
extends Node3D

@export var models : Array[GeometryInstance3D]

const BLUEPRINT_GHOST_MAT = preload("res://materials/blueprint_ghost_mat.tres")

func make_transparent():
	for model in models:
		model.material_override = BLUEPRINT_GHOST_MAT

func place():
	pass
