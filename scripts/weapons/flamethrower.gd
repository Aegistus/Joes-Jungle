class_name Flamethrower
extends Gun

@export var max_light_energy := 6.0
@export var light_up_time := .5
@export var dim_light_time := 1.5
@export var light_color : Color

@onready var fire_particles = $gun_model/Fire_Particles
@onready var flame_hitbox : ShapeCast3D = $gun_model/FlameHitbox
@onready var flame_check_timer = $FlameCheckTimer
@onready var flamethrower_start_audio_player = $FlamethrowerStartAudioPlayer
@onready var flamethrower_loop_audio_player = $FlamethrowerLoopAudioPlayer
@onready var light_spawn_point = $gun_model/LightSpawnPoint

const FIRE = preload("res://scenes/particles/fire.tscn")
const FLAMETHROWER_TANK = preload("res://scenes/weapons/flamethrower_tank.tscn")

var backpack
var light

func _ready():
	flame_hitbox.enabled = false
	flame_check_timer.timeout.connect(set_targets_on_fire)

func shoot():
	fire_particles.play()
	flame_hitbox.enabled = true
	flame_check_timer.start()
	flamethrower_start_audio_player.play()
	flamethrower_loop_audio_player.play()
	light = OmniLight3D.new()
	get_parent_node_3d().add_child(light)
	light.global_position = light_spawn_point.global_position
	var tween = get_tree().create_tween()
	tween.tween_property(light, "light_energy", max_light_energy, light_up_time)

func shoot_end():
	fire_particles.stop()
	flame_hitbox.enabled = false
	flame_check_timer.stop()
	flamethrower_loop_audio_player.stop()
	if light != null:
		light.reparent(get_tree().root)
		var tween = get_tree().create_tween()
		tween.tween_property(light, "light_energy", 0, dim_light_time)
		tween.tween_callback(light.queue_free).set_delay(dim_light_time)

func set_targets_on_fire():
	var hits = flame_hitbox.collision_result as Array[Node]
	for i in hits.size():
		if hits[i].collider != null and hits[i].collider.is_in_group("enemy"):
			var fire = FIRE.instantiate()
			hits[i].collider.add_child(fire)
			fire.global_position = hits[i].collider.global_position

func equip(player : Node3D):
	if backpack == null:
		var backpack_bone = player.get_node("PlayerModel/Model/Armature/GeneralSkeleton/BackpackBone")
		backpack = FLAMETHROWER_TANK.instantiate()
		backpack_bone.add_child(backpack)
	else:
		backpack.visible = true

func unequip():
	backpack.visible = false
