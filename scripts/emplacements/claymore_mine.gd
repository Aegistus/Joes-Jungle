class_name Claymore
extends Emplacement

@export var min_damage = 10
@export var max_damage = 20
@export var field_of_fire_degrees := 60.0
@export var base_penetration := 3

const BULLET_IMPACT_TERRAIN = preload("res://scenes/particles/bullet_impact_terrain.tscn")
const PENETRATION_DAMAGE_REDUCTION = .25

@onready var flesh_hit = preload("res://scenes/audio_scenes/flesh_hit_audio_source.tscn")
@onready var stone_hit = preload("res://scenes/audio_scenes/stone_hit_audio_source.tscn")
@onready var raycasts = %Raycasts
@onready var enemy_detector = %EnemyDetector

func place():
	enemy_detector.monitoring = true

func trigger(area):
	if area.is_in_group("enemy"):
		explode()

func explode():
	for ray in raycasts.get_children():
		shoot_with_raycast(ray)
	queue_free()

func shoot_with_raycast(raycast : RayCast3D):
	# apply accuracy
	raycast.rotation_degrees = Vector3(0,0,0)
	var degree_change = randf() * field_of_fire_degrees - (field_of_fire_degrees / 2)
	var radians_change = degree_change * (PI / 180.0)
	raycast.rotate_object_local(Vector3.UP, radians_change)
	
	# shoot with penetration
	var already_hit : Array[CollisionObject3D] = []
	for i in base_penetration:
		raycast.force_raycast_update()
		var collided = raycast.get_collider() as CollisionObject3D
		var collision_point = raycast.get_collision_point()
		var collision_normal = raycast.get_collision_normal()
		if collided == null:
			collided = raycast.get_collider() as CSGShape3D
			if collided != null:
				generate_impact_effects(collided, collision_point, collision_normal)
			break
		if collided != null:
			generate_impact_effects(collided, collision_point, collision_normal)
			if collided.is_in_group("enemy"):
				var rotation = (collision_point - global_position).normalized().inverse()
				rotation.y += 180
				var damage = randi_range(min_damage, max_damage)
				damage -= i * PENETRATION_DAMAGE_REDUCTION * damage
				collided.hit(damage, collision_point, rotation)
				already_hit.append(collided)
				raycast.add_exception(collided)
	for i in already_hit.size():
		raycast.remove_exception(already_hit[i])

func generate_impact_effects(collided, collision_point, collision_normal):
	if collided.is_in_group("enemy"):
		var hit_audio = flesh_hit.instantiate()
		get_parent().add_child(hit_audio)
		hit_audio.global_position = collision_point
	else:
		var impact = BULLET_IMPACT_TERRAIN.instantiate()
		collided.add_child(impact)
		impact.global_position = collision_point
		var direction = impact.global_position + collision_point
		if collision_normal != Vector3.UP: # this check prevents occasional error
			impact.look_at(direction)
		impact.emitting = true
		var hit_audio = stone_hit.instantiate()
		get_parent().add_child(hit_audio)
		hit_audio.global_position = collision_point
