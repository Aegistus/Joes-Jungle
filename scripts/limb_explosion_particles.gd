extends Node3D

@onready var skin = $Skin
@onready var gore = $Gore
@onready var blood = $Blood
@onready var timer = $Timer

func _ready():
	skin.emitting = true
	gore.emitting = true
	blood.emitting = true
	timer.start()
	timer.timeout.connect(func(): queue_free())
