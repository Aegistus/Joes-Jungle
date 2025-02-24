class_name BarbedWire
extends Emplacement

@export var min_damage = 2
@export var max_damage = 3
@export var slow = .5
@export var max_health := 100

@onready var animation_player = %AnimationPlayer
@onready var damage_timer = $DamageTimer
@onready var damage_audio_source = $DamageAudioSource
@onready var model = $Model
@onready var enemy_detector = %EnemyDetector
@onready var ragdoll_collider_shape = $RagdollCollider/RagdollColliderShape
@onready var destroyed_model = $DestroyedModel

var self_damage = 10
var damage_interval = 1
var current_health
var in_wire = []
var alive = true

func place():
	alive = true
	current_health = max_health
	animation_player.play("place")
	damage_timer.wait_time = damage_interval
	damage()
	model.visible = true
	enemy_detector.monitoring = true
	ragdoll_collider_shape.disabled = false
	destroyed_model.visible = false

func damage():
	while alive:
		damage_timer.start()
		await damage_timer.timeout
		if in_wire.size() > 0:
			animation_player.play("damage")
			damage_audio_source.play()
		for zombie in in_wire:
			zombie.quick_hit(randi_range(min_damage, max_damage))
		current_health -= self_damage * in_wire.size()
		if current_health <= 0:
			destroy()

func destroy():
	alive = false
	in_wire.clear()
	model.visible = false
	enemy_detector.monitoring = false
	ragdoll_collider_shape.disabled = true
	destroyed_model.visible = true

func _on_enemy_detector_body_entered(body):
	in_wire.append(body)
	body.slow(slow)

func _on_enemy_detector_body_exited(body):
	in_wire.erase(body)
	body.slow(1)
