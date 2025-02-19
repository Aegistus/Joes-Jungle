class_name AutoShotgun
extends Gun

@export var shot_delay := .2

@onready var timer = $Timer

var current_time

func _ready():
	super()
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(shoot_continue)

func shoot():
	if ammo.current_ammo > 0:
		animation_player.stop(true)
		animation_player.play("shoot")
		gun_audio_player.play()
		can_shoot = false
		ammo.use_ammo()
		for i in raycast_parent.get_child_count():
			var raycast = raycast_parent.get_child(i) as RayCast3D
			shoot_with_raycast(raycast)
		on_shoot.emit()
	else:
		# play dead mans click
		dry_shot_audio_player.play()
	if ammo.current_ammo > 0:
		timer.wait_time = shot_delay
		timer.start()

func shoot_continue():
	shoot()

func shoot_end():
	timer.stop()
