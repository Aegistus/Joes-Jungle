extends Node3D

@export var damage_min := 1
@export var damage_max := 3
@export var lifetime = 6

@onready var shape_cast_3d = $ShapeCast3D
@onready var flame_damage_timer = $FlameDamageTimer
@onready var lifetime_timer = $LifetimeTimer
@onready var flames = $Flames
@onready var smoke = $Smoke
@onready var embers = $Embers
@onready var light = $Light

func _ready():
	flame_damage_timer.start()
	flame_damage_timer.timeout.connect(damage_colliding)
	lifetime_timer.wait_time = lifetime
	lifetime_timer.timeout.connect(destroy)
	lifetime_timer.start()

func damage_colliding():
	var hits = shape_cast_3d.collision_result
	for i in hits.size():
		if hits[i].collider != null and hits[i].collider.is_in_group("enemy"):
			hits[i].collider.quick_hit(randi_range(damage_min, damage_max))

func destroy():
	flames.emitting = false
	smoke.emitting = false
	var tween = get_tree().create_tween()
	tween.tween_property(light, "light_energy", 1, 3)
	tween.tween_property(light, "light_energy", 0, 6)
	await get_tree().create_timer(3).timeout
	embers.emitting = false
	await get_tree().create_timer(6).timeout
	queue_free()
