class_name BarbedWire
extends Emplacement

@export var min_damage = 2
@export var max_damage = 3
@export var slow = .5

@onready var animation_player = %AnimationPlayer
@onready var damage_timer = $DamageTimer

var self_damage = 2
var damage_interval = 1
var current_health = 100
var in_wire = []

func place():
	animation_player.play("place")
	damage_timer.wait_time = damage_interval
	damage()

func damage():
	while true:
		damage_timer.start()
		await damage_timer.timeout
		if in_wire.size() > 0:
			animation_player.play("damage")
		for zombie in in_wire:
			zombie.quick_hit(randi_range(min_damage, max_damage))

func _on_enemy_detector_body_entered(body):
	in_wire.append(body)
	body.slow(slow)

func _on_enemy_detector_body_exited(body):
	in_wire.erase(body)
	body.slow(1)
