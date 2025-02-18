class_name BarricadeEmplacement
extends Emplacement

@export var max_health := 100.0

@onready var collision_shape_3d = $StaticBody3D/CollisionShape3D
@onready var hurtbox = $Hurtbox
@onready var animation_player = %AnimationPlayer

var current_health

func _ready():
	animation_player.play("default")
	current_health = max_health
	hurtbox.monitoring = true
	hurtbox.monitorable = true

func place():
	collision_shape_3d.disabled = false
	animation_player.play("place")

func damage(amount):
	current_health -= amount
	if current_health <= 0:
		queue_free()
