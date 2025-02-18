extends Node3D

@onready var timer = $Timer
@onready var sparks = $Sparks
@onready var flash = $Flash
@onready var fire = $Fire
@onready var smoke = $Smoke

func _ready():
	sparks.emitting = true
	flash.emitting = true
	fire.emitting = true
	smoke.emitting = true
	timer.timeout.connect(func(): queue_free())
	timer.start()
