extends GPUParticles3D

@onready var timer = $Timer
@onready var darker_material = $DarkerMaterial
@onready var dust = $Dust

var destroy_after = 2.0

func _ready():
	darker_material.emitting = true
	dust.emitting = true
	timer.wait_time = destroy_after
	timer.timeout.connect(queue_free)
	timer.start()
