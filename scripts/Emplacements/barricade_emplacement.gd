class_name BarricadeEmplacement
extends Emplacement

@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D

func place():
	collision_shape_3d.disabled = false
