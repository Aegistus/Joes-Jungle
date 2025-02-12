extends Node3D

@export var damage_min := 1
@export var damage_max := 3
@export var lifetime = 6

@onready var shape_cast_3d = $ShapeCast3D
@onready var flame_damage_timer = $FlameDamageTimer
@onready var lifetime_timer = $LifetimeTimer

func _ready():
	flame_damage_timer.start()
	flame_damage_timer.timeout.connect(damage_colliding)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.timeout.connect(func(): queue_free())
	lifetime_timer.start()

func damage_colliding():
	var hits = shape_cast_3d.collision_result
	for i in hits.size():
		if hits[i].collider != null and hits[i].collider.is_in_group("enemy"):
			hits[i].collider.quick_hit(randi_range(damage_min, damage_max))
