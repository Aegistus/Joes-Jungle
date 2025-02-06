extends AudioStreamPlayer3D

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(func(): queue_free())
