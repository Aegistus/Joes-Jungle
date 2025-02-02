class_name MachineGun
extends Gun

@export var shot_delay := .2

var current_time
@onready var timer = $Timer

func _ready():
	super()
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(shoot_continue)

func shoot():
	can_shoot = true
	super()
	if current_ammo > 0:
		timer.wait_time = shot_delay
		timer.start()

func shoot_continue():
	shoot()

func shoot_end():
	timer.stop()
