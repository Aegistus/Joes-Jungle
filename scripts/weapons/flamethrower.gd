class_name Flamethrower
extends Gun

@onready var fire_particles = $gun_model/Fire_Particles
@onready var flame_hitbox : ShapeCast3D = $gun_model/FlameHitbox
@onready var flame_check_timer = $FlameCheckTimer

const FIRE = preload("res://scenes/particles/fire.tscn")

func _ready():
	flame_hitbox.enabled = false
	flame_check_timer.timeout.connect(set_targets_on_fire)

func shoot():
	fire_particles.play()
	flame_hitbox.enabled = true
	flame_check_timer.start()

func shoot_end():
	fire_particles.stop()
	flame_hitbox.enabled = false
	flame_check_timer.stop()

func set_targets_on_fire():
	var hits = flame_hitbox.collision_result as Array[Node]
	for i in hits.size():
		if hits[i].collider != null and hits[i].collider.is_in_group("enemy"):
			var fire = FIRE.instantiate()
			hits[i].collider.add_child(fire)
			fire.global_position = hits[i].collider.global_position
