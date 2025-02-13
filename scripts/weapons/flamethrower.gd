class_name Flamethrower
extends Gun

@onready var fire_particles = $gun_model/Fire_Particles
@onready var flame_hitbox : ShapeCast3D = $gun_model/FlameHitbox
@onready var flame_check_timer = $FlameCheckTimer
@onready var flamethrower_start_audio_player = $FlamethrowerStartAudioPlayer
@onready var flamethrower_loop_audio_player = $FlamethrowerLoopAudioPlayer
@onready var omni_light_3d = $gun_model/OmniLight3D

const FIRE = preload("res://scenes/particles/fire.tscn")
const FLAMETHROWER_TANK = preload("res://scenes/weapons/flamethrower_tank.tscn")

var backpack

func _ready():
	flame_hitbox.enabled = false
	omni_light_3d.visible = false
	flame_check_timer.timeout.connect(set_targets_on_fire)

func shoot():
	fire_particles.play()
	flame_hitbox.enabled = true
	flame_check_timer.start()
	flamethrower_start_audio_player.play()
	flamethrower_loop_audio_player.play()
	omni_light_3d.visible = true

func shoot_end():
	fire_particles.stop()
	flame_hitbox.enabled = false
	flame_check_timer.stop()
	flamethrower_loop_audio_player.stop()
	omni_light_3d.visible = false

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
