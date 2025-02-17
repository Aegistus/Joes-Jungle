class_name BarricadeEmplacement
extends Emplacement

@export var max_health := 100.0

@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D

var current_health

func _ready():
	current_health = max_health

func place():
	collision_shape_3d.disabled = false

func damage(amount):
	current_health -= amount
	if current_health <= 0:
		queue_free()
